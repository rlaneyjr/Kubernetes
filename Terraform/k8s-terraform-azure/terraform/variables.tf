variable "client_id" {}
variable "client_secret" {}

variable "agent_count" {
    default = 3
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8stest"
}

variable cluster_name {
    default = "k8stest"
}

variable kube_version {
  default = "1.10.6"
}

variable resource_group_name {
    default = "azure-k8stest"
}

variable location {
    default = "Central US"
}