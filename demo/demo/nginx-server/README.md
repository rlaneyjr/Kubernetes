# nginx-server demo
 - supported Kubernetes version: available from v1.7
 - supported agent OS: Linux 

# About
This demo would set up an nginx server, including following features:
 - Storage: azure file plugin
 - Network: load balancer
 - Autoscaler: VMSS & cluster autoscaler support

# Prerequisite
An kubernetes cluster with a azure file storage class(name as `azurefile`) should be set up before running deployment scripts.
 - [AKS cluster step-by-step setup](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough)

# Deploy nginx-server application on a kubernetes cluster
```
kubectl apply -f https://raw.githubusercontent.com/andyzhangx/demo/master/demo/nginx-server/nginx-server-azurefile.yaml
```
> On Azure China, run with following config:
```
kubectl apply -f https://raw.githubusercontent.com/andyzhangx/demo/master/demo/nginx-server/nginx-server-azurefile-mooncake.yaml
```

 - check deployment status
```
watch kubectl get deployment -o wide
watch kubectl get po -o wide
```

A Kubernetes service is created which exposes the application to the internet. This process can take a few minutes.
 - To monitor progress, use the `kubectl get service` command with the `--watch` argument.
```
kubectl get service nginx-server --watch
```
 - Initially the `EXTERNAL-IP` for the `nginx-server` service appears as pending.
```
nginx-server   10.0.34.242   <pending>     80:30676/TCP   7s
```

 - Once the `EXTERNAL-IP` address has changed from `pending` to an IP address, use CTRL-C to stop the kubectl watch process.
```
nginx-server   10.0.34.242   52.179.23.131   80:30676/TCP   2m
```

 - To see the application, browse to the external IP address, e.g. `http://52.151.27.123/`

## [Set up Cluster Autoscaler on Azure](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler/cloudprovider/azure)
 - Use `az vmss list -o table` to get vmss name
```
# az vmss list -o table
Name                         ResourceGroup      Location    Zones      Capacity  UpgradePolicy
---------------------------  -----------------  ----------  -------  ----------  ---------------
k8s-agentpool-40389373-vmss  ANDY-VMSS1102      westus2                       1  Manual
k8s-agentpool-39789145-vmss  ANDY-VMSS110APHA1  westus2                       1  Manual

```

## Manually scale pods
```
kubectl scale --replicas=9 deployment/nginx-server
```

## [Autoscale pods](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-scale#autoscale-pods)
```
kubectl autoscale deployment nginx-server --cpu-percent=50 --min=3 --max=10
kubectl get hpa
```

## [Update an application](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-app-update)

### clean up
```
kubectl delete service nginx-server
kubectl delete deployment nginx-server
kubectl delete pvc pvc-azurefile
```

### Links


