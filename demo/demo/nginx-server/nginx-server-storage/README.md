# A nginx-server demo with multiple storage drivers
 - supported Kubernetes version: available from v1.7
 - supported agent OS: Linux 

# About
This demo would set up a simple nginx-server, the data is stored in different storage drivers: azure disk, azure file, hostpath(local disk).

# Prerequisite
 - An kubernetes cluster with a azure file storage class(name as `azurefile`) should be set up before running deployment scripts.
 - [Install blobfuse driver on a kubernetes cluster](https://github.com/andyzhangx/kubernetes-drivers/tree/master/flexvolume/blobfuse#install-blobfuse-driver-on-a-kubernetes-cluster)
 - [create a secret which stores azure storage account name and key for blobfuse driver](https://github.com/andyzhangx/kubernetes-drivers/tree/master/flexvolume/blobfuse#1-create-a-secret-which-stores-azure-storage-account-name-and-key)

# Deploy nginx-server application on a kubernetes cluster
```
kubectl create -f https://raw.githubusercontent.com/andyzhangx/demo/master/demo/nginx-server/nginx-server-storage/nginx-server-storage-blobfuse.yaml
```
 - check deployment status
```
watch kubectl get deployment -o wide
watch kubectl get po -o wide
```

A Kubernetes service is created which exposes the application to the internet. This process can take a few minutes.
 - To monitor progress, use the `kubectl get service` command with the `--watch` argument.
```
kubectl get service nginx-server-storage --watch
```
 - Initially the `EXTERNAL-IP` for the `nginx-server-storage` service appears as pending.
```
nginx-server-storage   10.0.34.242   <pending>     80:30676/TCP   7s
```

 - Once the `EXTERNAL-IP` address has changed from `pending` to an IP address, use CTRL-C to stop the kubectl watch process.
```
nginx-server-storage   10.0.34.242   52.179.23.131   80:30676/TCP   2m
```

 - To see the application, browse to the external IP address, e.g. `http://52.151.27.123/`


# [Update an application](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-app-update)

### clean up
```
kubectl delete service nginx-server-storage
kubectl delete deployment nginx-server-storage
kubectl delete pvc pvc-azuredisk
kubectl delete pvc pvc-azurefile
```

### Links


