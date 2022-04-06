module "cluster" {
  source = "cloud-native-toolkit/ocp-vpc/ibm"
  version = "1.13.2"

  cos_id = var.cluster_cos_id
  disable_public_endpoint = var.cluster_disable_public_endpoint
  exists = var.cluster_exists
  flavor = var.cluster_flavor
  force_delete_storage = var.cluster_force_delete_storage
  ibmcloud_api_key = var.ibmcloud_api_key
  kms_enabled = var.cluster_kms_enabled
  kms_id = var.cluster_kms_id
  kms_key_id = var.cluster_kms_key_id
  kms_private_endpoint = var.cluster_kms_private_endpoint
  login = var.cluster_login
  name = var.cluster_name
  name_prefix = var.name_prefix
  ocp_entitlement = var.cluster_ocp_entitlement
  ocp_version = var.ocp_version
  region = var.region
  resource_group_name = module.resource_group.name
  sync = module.resource_group.sync
  tags = var.cluster_tags == null ? null : jsondecode(var.cluster_tags)
  vpc_name = module.cluster_subnets.vpc_name
  vpc_subnet_count = module.cluster_subnets.count
  vpc_subnets = module.cluster_subnets.subnets
  worker_count = var.worker_count
}
module "cluster_subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.2"

  _count = var.cluster_subnets__count
  acl_rules = var.cluster_subnets_acl_rules == null ? null : jsondecode(var.cluster_subnets_acl_rules)
  gateways = var.cluster_subnets_gateways == null ? null : jsondecode(var.cluster_subnets_gateways)
  ipv4_address_count = var.cluster_subnets_ipv4_address_count
  ipv4_cidr_blocks = var.cluster_subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.cluster_subnets_ipv4_cidr_blocks)
  label = var.cluster_subnets_label
  provision = var.cluster_subnets_provision
  region = var.region
  resource_group_name = module.resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.cluster_subnets_zone_offset
}
module "ibm-portworx" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-portworx?ref=v1.0.4"

  cluster_name = module.cluster.name
  create_external_etcd = var.ibm-portworx_create_external_etcd
  etcd_members_cpu_allocation_count = var.ibm-portworx_etcd_members_cpu_allocation_count
  etcd_members_disk_allocation_mb = var.ibm-portworx_etcd_members_disk_allocation_mb
  etcd_members_memory_allocation_mb = var.ibm-portworx_etcd_members_memory_allocation_mb
  etcd_password = var.ibm-portworx_etcd_password
  etcd_plan = var.ibm-portworx_etcd_plan
  etcd_secret_name = var.ibm-portworx_etcd_secret_name
  etcd_service_endpoints = var.ibm-portworx_etcd_service_endpoints
  etcd_username = var.ibm-portworx_etcd_username
  etcd_version = var.ibm-portworx_etcd_version
  ibmcloud_api_key = var.ibmcloud_api_key
  name_prefix = var.name_prefix
  provision = var.ibm-portworx_provision
  region = var.region
  resource_group_name = module.resource_group.name
  storage_capacity = var.ibm-portworx_storage_capacity
  storage_iops = var.ibm-portworx_storage_iops
  storage_profile = var.ibm-portworx_storage_profile
  worker_count = module.cluster.total_worker_count
  workers = module.cluster.workers
}
module "ibm-vpc" {
  source = "cloud-native-toolkit/vpc/ibm"
  version = "1.15.5"

  address_prefix_count = var.ibm-vpc_address_prefix_count
  address_prefixes = var.ibm-vpc_address_prefixes == null ? null : jsondecode(var.ibm-vpc_address_prefixes)
  base_security_group_name = var.ibm-vpc_base_security_group_name
  internal_cidr = var.ibm-vpc_internal_cidr
  name = var.ibm-vpc_name
  name_prefix = var.name_prefix
  provision = var.ibm-vpc_provision
  region = var.region
  resource_group_name = module.resource_group.name
}
module "resource_group" {
  source = "cloud-native-toolkit/resource-group/ibm"
  version = "3.2.6"

  ibmcloud_api_key = var.resource_group_ibmcloud_api_key
  resource_group_name = var.resource_group_name
  sync = var.resource_group_sync
}
