
/*az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/7c6eb568-5534-4e1f-8424-da7cb19ccb83"
#{ "displayName": "azure-cli-2022-11-13-08-53-29","sp cr
#  "appId": "0d3bd802-3f86-4228-838b-2524a240b00d",vHb63",
#  "displayName": "azure-cli-2022-11-13-08-58-13","
#  "password": "SH18Q~ovC7vZUjpdoHiE6o81AiBM7sA8Km2kQbr7",
#  "tenant": "638ce9cf-6537-491e-8950-90d7dfdb70aa"sp create-for-rbac --role="Contributor" --scopes="/subscriptions/7c6eb568-5534-4e1f-8424-da7cb19ccb83"
#
} */

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.1.0" # default here was 3.0.0
    }
  }
  required_version = ">=1.1.0" # this was added to accomodate collaboration
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  alias = "dev"
  subscription_id = "7c6eb568-5534-4e1f-8424-da7cb19ccb83"
  client_id       = "0d3bd802-3f86-4228-838b-2524a240b00d"
  client_secret   = "SH18Q~ovC7vZUjpdoHiE6o81AiBM7sA8Km2kQbr7"
  tenant_id       = "638ce9cf-6537-491e-8950-90d7dfdb70aa"
}
/*
resource "azurerm_resource_group" "example" {
  name     = var.rgname
  location = var.rglocation
}*

resource "azurerm_resource_group" "example" {
  name     = var.rgdetails[1]
  location = var.rgdetails[0]
}  */


# using the type = map to create an inbound rule on an NSG
/*
resource "azurerm_network_security_group" "example" {
  name                = "az-wus-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = var.security_rule.name
    priority                   = var.security_rule.priority
    direction                  = var.security_rule.direction
    access                     = var.security_rule.access
    protocol                   = var.security_rule.protocol
    source_port_range          = var.security_rule.source_port_range
    destination_port_range     = var.security_rule.destination_port_range
    source_address_prefix      = var.security_rule.source_address_prefix
    destination_address_prefix = var.security_rule.destination_address_prefix
  }
}  */
# looping in list argument -> count to create multiple resource groups
/*resource "azurerm_resource_group" "example" {
  count    = length(var.rgnames)
  name     = var.rgnames[count.index] #index changes for every iteration
  location = "westus"
} */
# looping in MAP for each key and value
/*resource "azurerm_resource_group" "name" {
  for_each = var.rgdetails
  name =each.key
  location=each.value
} */

/*
# Conditional Expression 
resource "azurerm_resource_group" "example" {
  name     = "az-wus-rg"
  location = "West US"
}

resource "azurerm_storage_account" "example" {
  name                     = "fahad123"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = var.account_tier
  account_replication_type = var.account_tier == "Standard"? "LRS"  : "ZRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "blob"
}
resource "azurerm_storage_blob" "example" {
  name                   = "test.sh"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type                   = "Block"
  source                 = "C:\\terraform projects\\terraform-scripts\\test.sh" #must add extra backslash to every directory including file
}
*/

/* # dynamic block
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  dynamic "security_rule" { # dynamic block
    for_each = var.nsg_rules
    content {
    name                       = security_rule.value["name"]  #block.value.key
    priority                   = security_rule.value["priority"] 
    direction                  = security_rule.value["direction"] 
    access                     = security_rule.value["access"] 
    protocol                   = security_rule.value["protocol"] 
    source_port_range          = security_rule.value["source_port_range"] 
    destination_port_range     = security_rule.value["destination_port_range"] 
    source_address_prefix      = security_rule.value["source_address_prefix"] 
    destination_address_prefix = security_rule.value["destination_address_prefix"] 
  }
}
} */
/* locals {
  rgdetails  = csvdecode(file("./details.csv"))
  rgnames    = azurerm_resource_group.name[*].name
  rglocation = azurerm_resource_group.name[*].location
  testmap = {
    "az-west"      = "westus"
    "az-east"      = "eastus"
    "az-centralus" = "centralus"
  }
}
resource "azurerm_resource_group" "name" {
  count    = length(local.rgdetails)
  name     = local.rgdetails[count.index].rgname
  location = local.rgdetails[count.index].location
} */

# Local and remote provisioning
/*
resource "azurerm_resource_group" "example" {
  name     = "az-wus-rg"
  location = "West US"
}
resource "azurerm_virtual_network" "example" {
  name                = "az-wus-network"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "az-wus-internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "example" {
  provider = azurerm.dev
  name                = "az-wus-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}
resource "azurerm_public_ip" "example" {
  name                = "linux-publip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}
resource "azurerm_linux_virtual_machine" "example" {
  name                            = "az-linux-vm"
  resource_group_name             = azurerm_resource_group.example.name
  location                        = azurerm_resource_group.example.location
  size                            = "Standard_DS2_v2"
  admin_username                  = "adminuser"
  admin_password                  = "P@$$w0rd1234!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  provisioner "local-exec" { #local provisioner
    when       = create
    on_failure = continue #prevent tainting of resource
    command    = "echo $(self.public_ip_address) > public_ip.txt"
  }

  provisioner "file" {
    source      = "C:\\terraform projects\\terraform-scripts\\test.sh"
    destination = "/tmp/test.sh"
  }
  provisioner "remote-exec" {
    when       = create
    on_failure = continue
    inline = [
      "chmod +x /tmp/test.sh",
      "/tmp/test.sh",
      "rm /tmp/test.sh"
    ]
  }
  connection {
    type     = "ssh"
    user     = self.admin_username
    password = self.admin_password
    host     = self.public_ip_address
  }
}  */

# Module 
resource "azurerm_resource_group" "example" {
  provider = azurerm.dev
  name     = var.rgnames
  location = var.rglocation
}