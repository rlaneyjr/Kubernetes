resource "azurerm_resource_group" "k8s" {
    name     = "${var.resource_group_name}"
    location = "${var.location}"
}
#an attempt to keep the aci container group name (and dns label) somewhat unique
resource "random_integer" "random_int" {
  min = 100
  max = 999
}

# resource azurerm_network_security_group "aks_advanced_network" {
#   name                = "akc-${random_integer.random_int.result}-nsg"
#   location            = "${var.location}"
#   resource_group_name = "${azurerm_resource_group.k8s.name}"
# }

# resource "azurerm_virtual_network" "aks_advanced_network" {
#   name                = "akc-${random_integer.random_int.result}-vnet"
#   location            = "${var.location}"
#   resource_group_name = "${azurerm_resource_group.k8s.name}"
#   address_space       = ["10.1.0.0/16"]
# }

# resource "azurerm_subnet" "aks_subnet" {
#   name                      = "akc-${random_integer.random_int.result}-subnet"
#   resource_group_name       = "${azurerm_resource_group.k8s.name}"
#   network_security_group_id = "${azurerm_network_security_group.aks_advanced_network.id}"
#   address_prefix            = "10.1.0.0/24"
#   virtual_network_name      = "${azurerm_virtual_network.aks_advanced_network.name}"
#}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = "${var.cluster_name}"
    location            = "${azurerm_resource_group.k8s.location}"
    resource_group_name = "${azurerm_resource_group.k8s.name}"
    dns_prefix          = "${var.dns_prefix}"
    kubernetes_version = "${var.kube_version}"

    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
        key_data = "${file("${var.ssh_public_key}")}"
        }
    }

    agent_pool_profile {
        name            = "default"
        count           = "${var.agent_count}"
        vm_size         = "Standard_D2_V3"
        os_type         = "Linux"
        os_disk_size_gb = 30
        # Required for advanced networking
        #net_subnet_id = "${azurerm_subnet.aks_subnet.id}"
    }

    # network_profile {
    #   network_plugin     = "azure"
    #   dns_service_ip     = "10.0.0.10"
    #   docker_bridge_cidr = "172.17.0.1/16"
    #   service_cidr       = "10.0.0.0/16"
    # }

    service_principal {
        client_id     = "${var.client_id}"
        client_secret = "${var.client_secret}"
    }

    tags {
        Environment = "Development"
    }
}