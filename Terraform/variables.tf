variable "client_id" {
    default = "18f23f76-884f-4633-aef4-ea64cc8f3bfe"
}
variable "client_secret" {
    default = "87b9c4d9-0b78-442f-907c-96d6aca06d60"
}

variable "agent_count" {
    default = 3
}

variable "vm_size" {
    default = "Standard_B2ms"
}

variable "vm_username" {
    default = "rlaney"
}

variable "ssh_public_key" {
    default = "../private/cloud_id.pub"
}

variable "dns_prefix" {
    default = "htskube01"
}

variable cluster_name {
    default = "htskube01"
}

variable resource_group_name {
    default = "hts-eastus-monitor-rg1"
}

variable location {
    default = "East US"
}

