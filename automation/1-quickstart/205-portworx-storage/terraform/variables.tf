variable "resource_group_ibmcloud_api_key" {
  type = string
  description = "The IBM Cloud api key"
}
variable "resource_group_name" {
  type = string
  description = "The name of the resource group"
}
variable "resource_group_sync" {
  type = string
  description = "Value used to order the provisioning of the resource group"
  default = ""
}
variable "ibmcloud_api_key" {
  type = string
  description = "the value of ibmcloud_api_key"
}
variable "region" {
  type = string
  description = "the value of region"
}
variable "cluster_name" {
  type = string
  description = "The cluster where Portworx storage will be deployed."
  default = ""
}
variable "worker_count" {
  type = number
  description = "The number of worker nodes that should be provisioned for classic infrastructure"
  default = 3
}
variable "cluster_flavor" {
  type = string
  description = "The machine type that will be provisioned for classic infrastructure"
  default = ""
}
variable "ocp_version" {
  type = string
  description = "The version of the OpenShift cluster that should be provisioned (format 4.x)"
  default = "4.8"
}
variable "cluster_exists" {
  type = bool
  description = "Flag indicating if the cluster already exists (true or false)"
  default = true
}
variable "cluster_disable_public_endpoint" {
  type = bool
  description = "Flag indicating that the public endpoint should be disabled"
  default = false
}
variable "name_prefix" {
  type = string
  description = "The prefix name for the service. If not provided it will default to the resource group name"
  default = ""
}
variable "cluster_ocp_entitlement" {
  type = string
  description = "Value that is applied to the entitlements for OCP cluster provisioning"
  default = "cloud_pak"
}
variable "cluster_force_delete_storage" {
  type = bool
  description = "Attribute to force the removal of persistent storage associtated with the cluster"
  default = false
}
variable "cluster_tags" {
  type = string
  description = "Tags that should be added to the instance"
  default = "[]"
}
variable "cluster_cos_id" {
  type = string
  description = "The crn of the COS instance that will be used with the OCP instance"
  default = ""
}
variable "cluster_kms_enabled" {
  type = bool
  description = "Flag indicating that kms encryption should be enabled for this cluster"
  default = false
}
variable "cluster_kms_id" {
  type = string
  description = "The crn of the KMS instance that will be used to encrypt the cluster."
  default = null
}
variable "cluster_kms_key_id" {
  type = string
  description = "The id of the root key in the KMS instance that will be used to encrypt the cluster."
  default = null
}
variable "cluster_kms_private_endpoint" {
  type = bool
  description = "Flag indicating that the private endpoint should be used to connect the KMS system to the cluster."
  default = true
}
variable "cluster_login" {
  type = bool
  description = "Flag indicating that after the cluster is provisioned, the module should log into the cluster"
  default = false
}
variable "ibm-portworx_provision" {
  type = string
  description = "If set to true installs Portworx on the given cluster"
  default = "true"
}
variable "ibm-portworx_storage_capacity" {
  type = number
  description = "Storage capacity in GBs"
  default = 200
}
variable "ibm-portworx_storage_iops" {
  type = number
  description = "This is used only if a user provides a custom storage_profile"
  default = 10
}
variable "ibm-portworx_storage_profile" {
  type = string
  description = "The is the storage profile used for creating storage"
  default = "10iops-tier"
}
variable "ibm-portworx_create_external_etcd" {
  type = bool
  description = "Do you want to create an external_etcd? `True` or `False`"
  default = false
}
variable "ibm-portworx_etcd_members_cpu_allocation_count" {
  type = number
  description = "the value of ibm-portworx_etcd_members_cpu_allocation_count"
  default = 9
}
variable "ibm-portworx_etcd_members_disk_allocation_mb" {
  type = number
  description = "the value of ibm-portworx_etcd_members_disk_allocation_mb"
  default = 393216
}
variable "ibm-portworx_etcd_members_memory_allocation_mb" {
  type = number
  description = "the value of ibm-portworx_etcd_members_memory_allocation_mb"
  default = 24576
}
variable "ibm-portworx_etcd_plan" {
  type = string
  description = "the value of ibm-portworx_etcd_plan"
  default = "standard"
}
variable "ibm-portworx_etcd_version" {
  type = string
  description = "the value of ibm-portworx_etcd_version"
  default = "3.3"
}
variable "ibm-portworx_etcd_service_endpoints" {
  type = string
  description = "the value of ibm-portworx_etcd_service_endpoints"
  default = "private"
}
variable "ibm-portworx_etcd_username" {
  type = string
  description = "etcd_username: You may override for additional security."
  default = "portworxuser"
}
variable "ibm-portworx_etcd_password" {
  type = string
  description = "etcd_password: You may override for additional security."
  default = "etcdpassword123"
}
variable "ibm-portworx_etcd_secret_name" {
  type = string
  description = "etcd_secret_name: This should not be changed unless you know what you're doing."
  default = "px-etcd-certs"
}
variable "ibm-vpc_name" {
  type = string
  description = "The name of the vpc instance"
  default = ""
}
variable "ibm-vpc_provision" {
  type = bool
  description = "Flag indicating that the instance should be provisioned. If false then an existing instance will be looked up"
  default = false
}
variable "ibm-vpc_address_prefix_count" {
  type = number
  description = "The number of ipv4_cidr_blocks"
  default = 0
}
variable "ibm-vpc_address_prefixes" {
  type = string
  description = "List of ipv4 cidr blocks for the address prefixes (e.g. ['10.10.10.0/24']). If you are providing cidr blocks then a value must be provided for each of the subnets. If you don't provide cidr blocks for each of the subnets then values will be generated using the {ipv4_address_count} value."
  default = "[]"
}
variable "ibm-vpc_base_security_group_name" {
  type = string
  description = "The name of the base security group. If not provided the name will be based on the vpc name"
  default = ""
}
variable "ibm-vpc_internal_cidr" {
  type = string
  description = "The cidr range of the internal network"
  default = "10.0.0.0/8"
}
variable "cluster_subnets_zone_offset" {
  type = number
  description = "The offset for the zone where the subnet should be created. The default offset is 0 which means the first subnet should be created in zone xxx-1"
  default = 0
}
variable "cluster_subnets__count" {
  type = number
  description = "The number of subnets that should be provisioned"
  default = 3
}
variable "cluster_subnets_label" {
  type = string
  description = "Label for the subnets created"
  default = "default"
}
variable "cluster_subnets_gateways" {
  type = string
  description = "List of gateway ids and zones"
  default = "[]"
}
variable "cluster_subnets_ipv4_cidr_blocks" {
  type = string
  description = "List of ipv4 cidr blocks for the subnets that will be created (e.g. ['10.10.10.0/24']). If you are providing cidr blocks then a value must be provided for each of the subnets. If you don't provide cidr blocks for each of the subnets then values will be generated using the {ipv4_address_count} value."
  default = "[]"
}
variable "cluster_subnets_ipv4_address_count" {
  type = number
  description = "The size of the ipv4 cidr block that should be allocated to the subnet. If {ipv4_cidr_blocks} are provided then this value is ignored."
  default = 256
}
variable "cluster_subnets_provision" {
  type = bool
  description = "Flag indicating that the subnet should be provisioned. If 'false' then the subnet will be looked up."
  default = false
}
variable "cluster_subnets_acl_rules" {
  type = string
  description = "List of rules to set on the subnet access control list"
  default = "[]"
}
