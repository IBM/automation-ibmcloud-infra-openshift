module "cos" {
  source = "cloud-native-toolkit/object-storage/ibm"
  version = "4.1.0"

  common_tags = var.common_tags == null ? null : jsondecode(var.common_tags)
  ibmcloud_api_key = var.ibmcloud_api_key
  label = var.cos_label
  name_prefix = var.cs_name_prefix
  plan = var.cos_plan
  provision = var.cos_provision
  resource_group_name = module.cs_resource_group.name
  resource_location = var.cos_resource_location
  tags = var.cos_tags == null ? null : jsondecode(var.cos_tags)
}
module "cos_key" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-kms-key?ref=v1.5.4"

  dual_auth_delete = var.cos_key_dual_auth_delete
  force_delete = var.cos_key_force_delete
  kms_id = module.kms.guid
  kms_private_url = module.kms.private_url
  kms_public_url = module.kms.public_url
  label = var.cos_key_label
  name = var.cos_key_name
  name_prefix = var.vpc_name_prefix
  provision = var.cos_key_provision
  provision_key_rotation_policy = var.cos_key_provision_key_rotation_policy
  rotation_interval = var.cos_key_rotation_interval
}
module "cs_resource_group" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-resource-group?ref=v3.3.5"

  ibmcloud_api_key = var.ibmcloud_api_key
  purge_volumes = var.purge_volumes
  resource_group_name = var.cs_resource_group_name
  sync = var.cs_resource_group_sync
}
module "egress-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.14.0"

  _count = var.egress-subnets__count
  acl_rules = var.egress-subnets_acl_rules == null ? null : jsondecode(var.egress-subnets_acl_rules)
  common_tags = var.common_tags == null ? null : jsondecode(var.common_tags)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.egress-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.egress-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.egress-subnets_ipv4_cidr_blocks)
  label = var.egress-subnets_label
  provision = var.egress-subnets_provision
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  tags = var.egress-subnets_tags == null ? null : jsondecode(var.egress-subnets_tags)
  vpc_name = module.ibm-vpc.name
  zone_offset = var.egress-subnets_zone_offset
}
module "flow_log_bucket" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-object-storage-bucket?ref=v0.8.4"

  activity_tracker_crn = module.ibm-activity-tracker.crn
  allowed_ip = var.flow_log_bucket_allowed_ip == null ? null : jsondecode(var.flow_log_bucket_allowed_ip)
  cos_instance_id = module.cos.id
  cos_key_id = module.cos.key_id
  cross_region_location = var.flow_log_bucket_cross_region_location
  enable_object_versioning = var.flow_log_bucket_enable_object_versioning
  ibmcloud_api_key = var.ibmcloud_api_key
  kms_key_crn = module.cos_key.crn
  label = var.flow_log_bucket_label
  metrics_monitoring_crn = var.flow_log_bucket_metrics_monitoring_crn
  name = var.flow_log_bucket_name
  name_prefix = var.vpc_name_prefix
  provision = var.flow_log_bucket_provision
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  storage_class = var.flow_log_bucket_storage_class
  suffix = var.suffix
  vpc_ip_addresses = module.ibm-vpc.addresses
}
module "ibm-activity-tracker" {
  source = "cloud-native-toolkit/activity-tracker/ibm"
  version = "2.4.18"

  ibmcloud_api_key = var.ibmcloud_api_key
  plan = var.ibm-activity-tracker_plan
  resource_group_name = module.vpc_resource_group.name
  resource_location = var.region
  sync = var.ibm-activity-tracker_sync
  tags = var.ibm-activity-tracker_tags == null ? null : jsondecode(var.ibm-activity-tracker_tags)
}
module "ibm-flow-logs" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-flow-log?ref=v1.0.3"

  auth_id = var.ibm-flow-logs_auth_id
  cos_bucket_name = module.flow_log_bucket.bucket_name
  provision = var.ibm-flow-logs_provision
  resource_group_id = module.vpc_resource_group.id
  target_count = module.ibm-vpc.count
  target_ids = module.ibm-vpc.ids
  target_names = module.ibm-vpc.names
}
module "ibm-secrets-manager" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-secrets-manager?ref=v1.1.0"

  create_auth = var.ibm-secrets-manager_create_auth
  ibmcloud_api_key = var.ibmcloud_api_key
  kms_enabled = var.ibm-secrets-manager_kms_enabled
  kms_key_crn = module.cos_key.crn
  label = var.ibm-secrets-manager_label
  name = var.ibm-secrets-manager_name
  name_prefix = var.cs_name_prefix
  private_endpoint = var.ibm-secrets-manager_private_endpoint
  provision = var.ibm-secrets-manager_provision
  purge = var.ibm-secrets-manager_purge
  region = var.region
  resource_group_name = module.cs_resource_group.name
  trial = var.ibm-secrets-manager_trial
}
module "ibm-vpc" {
  source = "cloud-native-toolkit/vpc/ibm"
  version = "1.17.0"

  address_prefix_count = var.ibm-vpc_address_prefix_count
  address_prefixes = var.ibm-vpc_address_prefixes == null ? null : jsondecode(var.ibm-vpc_address_prefixes)
  base_security_group_name = var.ibm-vpc_base_security_group_name
  common_tags = var.common_tags == null ? null : jsondecode(var.common_tags)
  internal_cidr = var.ibm-vpc_internal_cidr
  name = var.ibm-vpc_name
  name_prefix = var.vpc_name_prefix
  provision = var.ibm-vpc_provision
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  tags = var.ibm-vpc_tags == null ? null : jsondecode(var.ibm-vpc_tags)
}
module "ibm-vpc-gateways" {
  source = "cloud-native-toolkit/vpc-gateways/ibm"
  version = "1.10.0"

  common_tags = var.common_tags == null ? null : jsondecode(var.common_tags)
  provision = var.ibm-vpc-gateways_provision
  region = var.region
  resource_group_id = module.vpc_resource_group.id
  tags = var.ibm-vpc-gateways_tags == null ? null : jsondecode(var.ibm-vpc-gateways_tags)
  vpc_name = module.ibm-vpc.name
}
module "ibm-vpn-server" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-vpn-server?ref=v0.2.3"

  auth_method = var.ibm-vpn-server_auth_method
  client_dns = var.ibm-vpn-server_client_dns == null ? null : jsondecode(var.ibm-vpn-server_client_dns)
  dns_cidr = var.ibm-vpn-server_dns_cidr
  enable_split_tunnel = var.ibm-vpn-server_enable_split_tunnel
  ibmcloud_api_key = var.ibmcloud_api_key
  name_prefix = var.vpc_name_prefix
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  resource_label = var.ibm-vpn-server_resource_label
  secrets_manager_guid = module.ibm-secrets-manager.guid
  services_cidr = var.ibm-vpn-server_services_cidr
  sm_region = var.ibm-vpn-server_sm_region
  subnet_ids = module.ingress-subnets.ids
  vpc_cidr = var.ibm-vpn-server_vpc_cidr
  vpc_id = module.ingress-subnets.vpc_id
  vpn_client_timeout = var.ibm-vpn-server_vpn_client_timeout
  vpn_server_port = var.ibm-vpn-server_vpn_server_port
  vpn_server_proto = var.ibm-vpn-server_vpn_server_proto
  vpnclient_ip = var.ibm-vpn-server_vpnclient_ip
}
module "ingress-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.14.0"

  _count = var.ingress-subnets__count
  acl_rules = var.ingress-subnets_acl_rules == null ? null : jsondecode(var.ingress-subnets_acl_rules)
  common_tags = var.common_tags == null ? null : jsondecode(var.common_tags)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.ingress-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.ingress-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.ingress-subnets_ipv4_cidr_blocks)
  label = var.ingress-subnets_label
  provision = var.ingress-subnets_provision
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  tags = var.ingress-subnets_tags == null ? null : jsondecode(var.ingress-subnets_tags)
  vpc_name = module.ibm-vpc.name
  zone_offset = var.ingress-subnets_zone_offset
}
module "kms" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-kms?ref=v0.3.6"

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
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-resource-group?ref=v3.3.5"

  ibmcloud_api_key = var.ibmcloud_api_key
  purge_volumes = var.purge_volumes
  resource_group_name = var.kms_resource_group_name
  sync = var.kms_resource_group_sync
}
module "vpc_resource_group" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-resource-group?ref=v3.3.5"

  ibmcloud_api_key = var.ibmcloud_api_key
  purge_volumes = var.purge_volumes
  resource_group_name = var.vpc_resource_group_name
  sync = var.vpc_resource_group_sync
}
