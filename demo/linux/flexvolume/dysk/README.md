# Attention: this page is NOT maintained any more, FlexVolume driver and doc has been moved to [github.com/Azure/kubernetes-volume-drivers](https://github.com/Azure/kubernetes-volume-drivers/tree/master/flexvolume/dysk).

# Kubernetes volume driver for Dysk
## 1. create a secret which stores dysk account name and password
```
kubectl create secret generic dyskcreds --from-literal accountname=USERNAME --from-literal accountkey="PASSWORD" --type="azure/dysk"
```

## 2. install flex volume driver on every linux agent node
```
sudo mkdir -p /etc/kubernetes/volumeplugins/azure~dysk
cd /etc/kubernetes/volumeplugins/azure~dysk
sudo wget -O dysk https://raw.githubusercontent.com/andyzhangx/Demo/master/linux/flexvolume/dysk/dysk
sudo chmod a+x dysk

sudo wget -O dysk.ko https://raw.githubusercontent.com/andyzhangx/Demo/master/linux/flexvolume/dysk/4.13.0-1005-azure/dysk.ko
sudo insmod dysk.ko
sudo lsmod | grep dysk
sudo wget -O dyskctl https://raw.githubusercontent.com/andyzhangx/Demo/master/linux/flexvolume/dysk/dyskctl
sudo chmod a+x dyskctl
sudo ./dyskctl list
```
#### Note:
Make sure `jq` package is installed on every node: 
```
sudo apt install jq -y
```

## 3. specify `volume-plugin-dir` in kubelet service config (skip this step from acs-engine v0.12.0)
```
sudo vi /etc/systemd/system/kubelet.service
  --volume=/etc/kubernetes/volumeplugins:/etc/kubernetes/volumeplugins:rw \
        --volume-plugin-dir=/etc/kubernetes/volumeplugins \
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```
Note:
1. `/etc/kubernetes/volumeplugins` has already been the default flexvolume plugin directory in acs-engine (starting from v0.12.0)
2. There would be one line of [kubelet log](https://github.com/andyzhangx/Demo/tree/master/debug#q-how-to-get-k8s-kubelet-logs-on-linux-agent) like below showing that `flexvolume-dysk/dysk` is loaded correctly
```
I0122 08:24:47.761479    2963 plugins.go:469] Loaded volume plugin "flexvolume-dysk/dysk"
```

## 4. create a pod with flexvolume-dysk mount on linux
kubectl create -f https://raw.githubusercontent.com/andyzhangx/Demo/master/linux/flexvolume/dysk/nginx-flex-dysk.yaml

#### watch the status of pod until its Status changed from `Pending` to `Running`
```watch kubectl describe po nginx-flex-dysk```

## 5. enter the pod container to do validation
```kubectl exec -it nginx-flex-dysk -- bash```

```
azureuser@k8s-master-77890142-0:~$ kubectl exec -it nginx-flex-dysk -- bash
root@nginx-flex-dysk:/# df -h
Filesystem         Size  Used Avail Use% Mounted on
overlay            291G  3.9G  287G   2% /
tmpfs              3.4G     0  3.4G   0% /dev
tmpfs              3.4G     0  3.4G   0% /sys/fs/cgroup
/dev/dyskI7cFTURv  5.8G   12M  5.5G   1% /data
/dev/sda1          291G  3.9G  287G   2% /etc/hosts
shm                 64M     0   64M   0% /dev/shm
tmpfs              3.4G   12K  3.4G   1% /run/secrets/kubernetes.io/serviceaccount
```

### Known issues
1. From v1.8.0, `echo -e` or `echo -ne` is not allowed in flexvolume driver script, related issue: [Error creating Flexvolume plugin from directory flexvolume](https://github.com/kubernetes/kubernetes/issues/54494)

2. You may get following error in the kubelet log when trying to use a flexvolume:
```
Volume has not been added to the list of VolumesInUse
```
You could let flexvolume plugin return following:
```
echo {"status": "Success", "capabilities": {"attach": false}}
```
Which means your [FlexVolume driver does not need Master-initiated Attach/Detach](https://docs.openshift.org/latest/install_config/persistent_storage/persistent_storage_flex_volume.html#flex-volume-drivers-without-master-initiated-attach-detach)

3. version of some commands in kubelet container is sometimes different from agent VM, e.g.
`findmnt` in `v1.8.4` is `findmnt from util-linux 2.25.2`, while in Ubuntu 16.04, kernel version `4.11.0-1015-azure`, it's `findmnt from util-linux 2.27.1`, and `v2.25.2` does not support `-J` parameter

### about this dysk flexvolume driver usage
1. You will get following error if you don't specify your secret type as driver name `dysk/dysk`
```
MountVolume.SetUp failed for volume "azure" : Couldn't get secret default/azure-secret
```


### Links
[Flexvolume doc](https://github.com/kubernetes/community/blob/master/contributors/devel/flexvolume.md)

More clear steps about flexvolume by Redhat doc: [Persistent Storage Using FlexVolume Plug-ins](https://docs.openshift.org/latest/install_config/persistent_storage/persistent_storage_flex_volume.html)

[dysk - Fast kernel-mode mount/unmount of AzureDisk](https://github.com/khenidak/dysk)
