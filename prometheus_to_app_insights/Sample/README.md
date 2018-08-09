# Sample
Use the provided yaml files to deploy a Prometheus server into the kubernetes cluster.
1. Run
```bash
kubectl get service
```
2. Check that the server is running currectly and providing with metrics by browsing the url: http://<external-service-ip:9090/metrics .
federated url is also available:
http://<external-service-ip:9090/federate?match[]={job%3D%22prometheus%22}
3. Any of the above URLs is suitable to be used in the 'Prometheus to Application Insights' application. Copy it and use it as described in the [application's readme file](../README.md).
