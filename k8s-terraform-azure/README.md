# Azure Kubernetes Service 
In this walkthrough you will use Terraform through the Azure Bash Cloud Shell to deploy an Azure Kubernetes Service.

## Prerequisites
* Azure Subscription

### Component Description
The Azure Kubernetes Service (AKS) is a PaaS which reduces the time and complexity of deploying Kubernetes onto virtual machines.

AKS deploys a three node management cluster which is free of charge and completely managed by the platform, meaning there is no need to feed and water the virtual machines, network or storage that underpin the management plane.

The agent pool (worker nodes/minions) are Ubuntu Linux with the following customisable attributes:
* OS Disk
* User Identity
* Network
* Storage
* Monitoring and Logging
