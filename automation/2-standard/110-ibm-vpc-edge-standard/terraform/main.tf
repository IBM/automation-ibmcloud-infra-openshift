module "bastion-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.2"

  _count = var.bastion-subnets__count
  acl_rules = var.bastion-subnets_acl_rules == null ? null : jsondecode(var.bastion-subnets_acl_rules)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.bastion-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.bastion-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.bastion-subnets_ipv4_cidr_blocks)
  label = var.bastion-subnets_label
  provision = var.bastion-subnets_provision
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.bastion-subnets_zone_offset
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
module "cos_key" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-kms-key?ref=v1.5.1"

  dual_auth_delete = var.cos_key_dual_auth_delete
  force_delete = var.cos_key_force_delete
  kms_id = module.kms.guid
  kms_private_url = module.kms.private_url
  kms_public_url = module.kms.public_url
  label = var.cos_key_label
  name = var.cos_key_name
  name_prefix = var.vpc_name_prefix
  provision = var.cos_key_provision
  rotation_interval = var.cos_key_rotation_interval
}
module "cs_resource_group" {
  source = "cloud-native-toolkit/resource-group/ibm"
  version = "3.2.10"

  ibmcloud_api_key = var.ibmcloud_api_key
  resource_group_name = var.cs_resource_group_name
  sync = var.cs_resource_group_sync
}
module "egress-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.2"

  _count = var.egress-subnets__count
  acl_rules = var.egress-subnets_acl_rules == null ? null : jsondecode(var.egress-subnets_acl_rules)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.egress-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.egress-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.egress-subnets_ipv4_cidr_blocks)
  label = var.egress-subnets_label
  provision = var.egress-subnets_provision
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.egress-subnets_zone_offset
}
module "ext-ingress-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.2"

  _count = var.ext-ingress-subnets__count
  acl_rules = var.ext-ingress-subnets_acl_rules == null ? null : jsondecode(var.ext-ingress-subnets_acl_rules)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.ext-ingress-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.ext-ingress-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.ext-ingress-subnets_ipv4_cidr_blocks)
  label = var.ext-ingress-subnets_label
  provision = var.ext-ingress-subnets_provision
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.ext-ingress-subnets_zone_offset
}
module "flow_log_bucket" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-object-storage-bucket?ref=v0.8.3"

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
  source = "github.com/cloud-native-toolkit/terraform-ibm-activity-tracker?ref=v2.4.6"

  ibmcloud_api_key = var.ibmcloud_api_key
  plan = var.ibm-activity-tracker_plan
  resource_group_name = module.vpc_resource_group.name
  resource_location = var.region
  sync = var.ibm-activity-tracker_sync
  tags = var.ibm-activity-tracker_tags == null ? null : jsondecode(var.ibm-activity-tracker_tags)
}
module "ibm-cert-manager" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-cert-manager?ref=v1.1.0"

  kms_enabled = var.ibm-cert-manager_kms_enabled
  kms_id = module.cos_key.kms_id
  kms_key_crn = module.cos_key.crn
  kms_private_endpoint = var.ibm-cert-manager_kms_private_endpoint
  kms_private_url = module.cos_key.kms_private_url
  kms_public_url = module.cos_key.kms_public_url
  label = var.ibm-cert-manager_label
  name = var.ibm-cert-manager_name
  name_prefix = var.cs_name_prefix
  private_endpoint = var.ibm-cert-manager_private_endpoint
  provision = var.ibm-cert-manager_provision
  region = var.region
  resource_group_name = module.cs_resource_group.name
}
module "ibm-flow-logs" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-flow-log?ref=v1.0.1"

  auth_id = var.ibm-flow-logs_auth_id
  cos_bucket_name = module.flow_log_bucket.bucket_name
  provision = var.ibm-flow-logs_provision
  resource_group_id = module.vpc_resource_group.id
  target_count = module.ibm-vpc.count
  target_ids = module.ibm-vpc.ids
  target_names = module.ibm-vpc.names
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
module "ibm-vpc-vpn-gateway" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-vpn-gateway?ref=v1.1.2"

  ibmcloud_api_key = var.ibmcloud_api_key
  label = var.ibm-vpc-vpn-gateway_label
  mode = var.ibm-vpc-vpn-gateway_mode
  provision = var.ibm-vpc-vpn-gateway_provision
  region = var.region
  resource_group_id = module.vpc_resource_group.id
  tags = var.ibm-vpc-vpn-gateway_tags == null ? null : jsondecode(var.ibm-vpc-vpn-gateway_tags)
  vpc_name = module.int-ingress-subnets.vpc_name
  vpc_subnet_count = module.int-ingress-subnets.count
  vpc_subnets = module.int-ingress-subnets.subnets
}
module "ibm-vpn-server" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-vpn-server?ref=v0.0.11"

  auth_method = var.ibm-vpn-server_auth_method
  certificate_manager_id = module.ibm-cert-manager.id
  client_dns = var.ibm-vpn-server_client_dns == null ? null : jsondecode(var.ibm-vpn-server_client_dns)
  enable_split_tunnel = var.ibm-vpn-server_enable_split_tunnel
  ibmcloud_api_key = var.ibmcloud_api_key
  name_prefix = var.vpc_name_prefix
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  resource_label = var.ibm-vpn-server_resource_label
  subnet_ids = module.int-ingress-subnets.ids
  vpc_id = module.int-ingress-subnets.vpc_id
  vpn_client_timeout = var.ibm-vpn-server_vpn_client_timeout
  vpn_server_port = var.ibm-vpn-server_vpn_server_port
  vpn_server_proto = var.ibm-vpn-server_vpn_server_proto
  vpnclient_ip = var.ibm-vpn-server_vpnclient_ip
}
module "int-ingress-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.2"

  _count = var.int-ingress-subnets__count
  acl_rules = var.int-ingress-subnets_acl_rules == null ? null : jsondecode(var.int-ingress-subnets_acl_rules)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.int-ingress-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.int-ingress-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.int-ingress-subnets_ipv4_cidr_blocks)
  label = var.int-ingress-subnets_label
  provision = var.int-ingress-subnets_provision
  region = var.region
  resource_group_name = module.vpc_resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.int-ingress-subnets_zone_offset
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
module "vpc_resource_group" {
  source = "cloud-native-toolkit/resource-group/ibm"
  version = "3.2.10"

  ibmcloud_api_key = var.ibmcloud_api_key
  resource_group_name = var.vpc_resource_group_name
  sync = var.vpc_resource_group_sync
}
module "vpc_ssh_bastion" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-vpc-ssh?ref=v1.7.1"

  label = var.vpc_ssh_bastion_label
  name = var.vpc_ssh_bastion_name
  name_prefix = var.vpc_name_prefix
  private_key = var.vpc_ssh_bastion_private_key
  private_key_file = var.vpc_ssh_bastion_private_key_file
  public_key = var.vpc_ssh_bastion_public_key
  public_key_file = var.vpc_ssh_bastion_public_key_file
  resource_group_name = module.vpc_resource_group.name
  rsa_bits = var.vpc_ssh_bastion_rsa_bits
}
module "vsi-bastion" {
  source = "github.com/cloud-native-toolkit/terraform-vsi-bastion?ref=v1.9.0"

  acl_rules = var.vsi-bastion_acl_rules
  allow_ssh_from = var.vsi-bastion_allow_ssh_from
  auto_delete_volume = var.vsi-bastion_auto_delete_volume
  base_security_group = module.ibm-vpc.base_security_group
  create_public_ip = var.vsi-bastion_create_public_ip
  ibmcloud_api_key = var.ibmcloud_api_key
  image_name = var.vsi-bastion_image_name
  init_script = var.vsi-bastion_init_script
  kms_enabled = var.vsi-bastion_kms_enabled
  kms_key_crn = module.cos_key.crn
  label = var.vsi-bastion_label
  profile_name = var.vsi-bastion_profile_name
  region = var.region
  resource_group_id = module.vpc_resource_group.id
  ssh_key_id = module.vpc_ssh_bastion.id
  tags = var.vsi-bastion_tags == null ? null : jsondecode(var.vsi-bastion_tags)
  target_network_range = var.vsi-bastion_target_network_range
  vpc_name = module.ibm-vpc.name
  vpc_subnet_count = module.bastion-subnets.count
  vpc_subnets = module.bastion-subnets.subnets
}
