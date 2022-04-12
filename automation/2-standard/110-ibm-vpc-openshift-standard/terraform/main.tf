module "cluster" {
  source = "cloud-native-toolkit/ocp-vpc/ibm"
  version = "1.13.2"

  cos_id = module.cos.id
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
  name_prefix = var.vpc_name_prefix
  ocp_entitlement = var.cluster_ocp_entitlement
  ocp_version = var.ocp_version
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  sync = module.vpc_resource_group.sync
  tags = var.cluster_tags == null ? null : jsondecode(var.cluster_tags)
  vpc_name = module.worker-subnets.vpc_name
  vpc_subnet_count = module.worker-subnets.count
  vpc_subnets = module.worker-subnets.subnets
  worker_count = var.worker_count
}
module "cos" {
  source = "cloud-native-toolkit/object-storage/ibm"
  version = "4.0.3"

  label = var.cos_label
  name_prefix = var.cs_name_prefix
  plan = var.cos_plan
  provision = var.cos_provision
  resource_group_name = module.cs_resource_group.name
  resource_location = var.cos_resource_location
  tags = var.cos_tags == null ? null : jsondecode(var.cos_tags)
}
module "cs_resource_group" {
  source = "cloud-native-toolkit/resource-group/ibm"
  version = "3.2.10"

  ibmcloud_api_key = var.ibmcloud_api_key
  resource_group_name = var.cs_resource_group_name
  sync = var.cs_resource_group_sync
}
module "ibm-logdna-bind" {
  source = "cloud-native-toolkit/log-analysis-bind/ibm"
  version = "1.3.3"

  cluster_id = module.cluster.id
  cluster_name = module.cluster.name
  ibmcloud_api_key = var.ibmcloud_api_key
  logdna_id = module.logdna.guid
  private_endpoint = var.private_endpoint
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  sync = module.sysdig-bind.sync
}
module "ibm-vpc" {
  source = "cloud-native-toolkit/vpc/ibm"
  version = "1.15.5"

  address_prefix_count = var.ibm-vpc_address_prefix_count
  address_prefixes = var.ibm-vpc_address_prefixes == null ? null : jsondecode(var.ibm-vpc_address_prefixes)
  base_security_group_name = var.ibm-vpc_base_security_group_name
  internal_cidr = var.ibm-vpc_internal_cidr
  name = var.ibm-vpc_name
  name_prefix = var.vpc_name_prefix
  provision = var.ibm-vpc_provision
  region = var.region
  resource_group_name = module.vpc_resource_group.name
}
module "ibm-vpc-gateways" {
  source = "cloud-native-toolkit/vpc-gateways/ibm"
  version = "1.8.2"

  provision = var.ibm-vpc-gateways_provision
  region = var.region
  resource_group_id = module.vpc_resource_group.id
  vpc_name = module.ibm-vpc.name
}
module "kms" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-kms?ref=v0.3.4"

  name = var.kms_name
  name_prefix = var.kms_name_prefix
  number_of_crypto_units = var.kms_number_of_crypto_units
  private_endpoint = var.private_endpoint
  provision = var.kms_provision
  region = var.kms_region
  resource_group_name = module.kms_resource_group.name
  service = var.kms_service
  tags = var.kms_tags == null ? null : jsondecode(var.kms_tags)
}
module "kms_resource_group" {
  source = "cloud-native-toolkit/resource-group/ibm"
  version = "3.2.10"

  ibmcloud_api_key = var.ibmcloud_api_key
  resource_group_name = var.kms_resource_group_name
  sync = var.kms_resource_group_sync
}
module "logdna" {
  source = "cloud-native-toolkit/log-analysis/ibm"
  version = "4.1.2"

  label = var.logdna_label
  name = var.logdna_name
  name_prefix = var.cs_name_prefix
  plan = var.logdna_plan
  provision = var.logdna_provision
  region = var.region
  resource_group_name = module.cs_resource_group.name
  tags = var.logdna_tags == null ? null : jsondecode(var.logdna_tags)
}
module "ocp_key" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-kms-key?ref=v1.5.1"

  dual_auth_delete = var.ocp_key_dual_auth_delete
  force_delete = var.ocp_key_force_delete
  kms_id = module.kms.guid
  kms_private_url = module.kms.private_url
  kms_public_url = module.kms.public_url
  label = var.ocp_key_label
  name = var.ocp_key_name
  name_prefix = var.vpc_name_prefix
  provision = var.ocp_key_provision
  rotation_interval = var.ocp_key_rotation_interval
}
module "sysdig" {
  source = "cloud-native-toolkit/cloud-monitoring/ibm"
  version = "4.1.2"

  label = var.sysdig_label
  name = var.sysdig_name
  name_prefix = var.cs_name_prefix
  plan = var.sysdig_plan
  provision = var.sysdig_provision
  region = var.region
  resource_group_name = module.cs_resource_group.name
  tags = var.sysdig_tags == null ? null : jsondecode(var.sysdig_tags)
}
module "sysdig-bind" {
  source = "cloud-native-toolkit/cloud-monitoring-bind/ibm"
  version = "1.3.3"

  access_key = module.sysdig.access_key
  cluster_id = module.cluster.id
  cluster_name = module.cluster.name
  guid = module.sysdig.guid
  ibmcloud_api_key = var.ibmcloud_api_key
  namespace = var.sysdig-bind_namespace
  private_endpoint = var.private_endpoint
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  sync = var.sysdig-bind_sync
}
module "vpc_resource_group" {
  source = "cloud-native-toolkit/resource-group/ibm"
  version = "3.2.10"

  ibmcloud_api_key = var.ibmcloud_api_key
  resource_group_name = var.vpc_resource_group_name
  sync = var.vpc_resource_group_sync
}
module "vpe-cos" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-vpe-gateway?ref=v1.6.0"

  ibmcloud_api_key = var.ibmcloud_api_key
  name_prefix = var.vpc_name_prefix
  region = var.region
  resource_crn = module.cos.crn
  resource_group_name = module.vpc_resource_group.name
  resource_label = module.cos.label
  resource_service = module.cos.service
  sync = var.vpe-cos_sync
  vpc_id = module.vpe-subnets.vpc_id
  vpc_subnet_count = module.vpe-subnets.count
  vpc_subnets = module.vpe-subnets.subnets
}
module "vpe-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.2"

  _count = var.vpe-subnets__count
  acl_rules = var.vpe-subnets_acl_rules == null ? null : jsondecode(var.vpe-subnets_acl_rules)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.vpe-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.vpe-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.vpe-subnets_ipv4_cidr_blocks)
  label = var.vpe-subnets_label
  provision = var.vpe-subnets_provision
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.vpe-subnets_zone_offset
}
module "worker-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.2"

  _count = var.worker_subnet_count
  acl_rules = var.worker-subnets_acl_rules == null ? null : jsondecode(var.worker-subnets_acl_rules)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.worker-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.worker-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.worker-subnets_ipv4_cidr_blocks)
  label = var.worker-subnets_label
  provision = var.worker-subnets_provision
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.worker-subnets_zone_offset
}
