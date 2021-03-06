###
# environment variables
###

#common

variable "environment" {
  description = "Development environment for resource; prod, non-prod, shared-services"
  type        = string
}

variable "region" {
  description = "Geographic region resource will be deployed into"
  type        = string
}

#network

variable "address_space" {
  description = "This is a list of the ip address ranges for the vnet"
  type        = list(any)
}

variable "address_prefix_aks" {
  description = "The address prefix to use for the aks node subnet."
  type        = list(string)
}

variable "address_prefix_agw" {
  description = "The address prefix to use for the agw subnet."
  type        = list(any)
}

variable "address_prefix_fw" {
  description = "The address prefixe to use for the fw subnet."
  type        = list(any)
}

variable "address_prefix_bastion" {
  description = "The address prefixe to use for the bastion subnet."
  type        = list(any)
}

variable "dns_service_ip" {
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). This is required when network_plugin is set to azure. Changing this forces a new resource to be created."
  type        = string
}

variable "docker_bridge_cidr" {
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. This is required when network_plugin is set to azure. Changing this forces a new resource to be created."
  type        = string
}

variable "service_cidr" {
  description = "The Network Range used by the Kubernetes service. This is required when network_plugin is set to azure. Changing this forces a new resource to be created."
  type        = string
}

#tags

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}