################
# Prod Variables
################

environment         = "prod"
region              = "eastus"
vnet_address_ranges = ["10.2.0.0/16"]
subnets_spoke = [
  {
    name        = "edge"
    subnet_cidr = "10.2.0.0/24"
  },
  {
    name        = "application"
    subnet_cidr = "10.2.1.0/24"
  },
  {
    name        = "data"
    subnet_cidr = "10.2.2.0/24"
  }
]
nsg_rules = [
  {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  },
  {
    name                       = "RDP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "3389"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  },
]

############################
#Mandatory Tagging Variables
############################

owner_tag          = ""
region_tag         = ""
cost_center_tag    = ""
approver_tag       = ""
service_hours_tag  = ""
cloudreach_ops_tag = ""

###########################
#Optional Tagging Variables
###########################

optional_tags = {}