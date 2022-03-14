module "argocd-bootstrap" {
  source = "github.com/cloud-native-toolkit/terraform-vsi-argocd-bootstrap?ref=v1.2.0"

  allow_deprecated_image = var.argocd-bootstrap_allow_deprecated_image
  bootstrap_branch = module.gitops-repo.bootstrap_branch
  bootstrap_path = module.gitops-repo.bootstrap_path
  cluster_type = module.cluster.platform.type_code
  git_token = module.gitops-repo.config_token
  git_username = module.gitops-repo.config_username
  gitops_repo_url = module.gitops-repo.config_repo_url
  ibmcloud_api_key = var.ibmcloud_api_key
  image_name = var.argocd-bootstrap_image_name
  ingress_subdomain = module.cluster.platform.ingress
  kms_enabled = var.argocd-bootstrap_kms_enabled
  kms_key_crn = var.argocd-bootstrap_kms_key_crn
  label = var.argocd-bootstrap_label
  olm_namespace = module.olm.olm_namespace
  operator_namespace = module.olm.target_namespace
  profile_name = var.argocd-bootstrap_profile_name
  region = var.region
  resource_group_name = module.resource_group.name
  sealed_secret_cert = module.sealed-secret-cert.cert
  sealed_secret_private_key = module.sealed-secret-cert.private_key
  server_url = module.cluster.platform.server_url
  vpc_name = module.bastion-subnets.vpc_name
  vpc_subnet_count = module.bastion-subnets.count
  vpc_subnets = module.bastion-subnets.subnets
}
module "at_resource_group" {
  source = "cloud-native-toolkit/resource-group/ibm"
  version = "3.2.2"

  provision = var.at_resource_group_provision
  resource_group_name = var.at_resource_group_name
  sync = var.at_resource_group_sync
}
module "bastion-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.1"

  _count = var.bastion-subnets__count
  acl_rules = var.bastion-subnets_acl_rules == null ? null : jsondecode(var.bastion-subnets_acl_rules)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.bastion-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.bastion-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.bastion-subnets_ipv4_cidr_blocks)
  label = var.bastion-subnets_label
  provision = var.bastion-subnets_provision
  region = var.region
  resource_group_name = module.resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.bastion-subnets_zone_offset
}
module "cluster" {
  source = "cloud-native-toolkit/ocp-vpc/ibm"
  version = "1.13.0"

  cos_id = module.cos.id
  disable_public_endpoint = var.cluster_disable_public_endpoint
  exists = var.cluster_exists
  flavor = var.cluster_flavor
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
  resource_group_name = module.resource_group.name
  sync = module.resource_group.sync
  vpc_name = module.worker-subnets.vpc_name
  vpc_subnet_count = module.worker-subnets.count
  vpc_subnets = module.worker-subnets.subnets
  worker_count = var.worker_count
}
module "cntk" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-namespace?ref=v1.11.1"

  argocd_namespace = var.cntk_argocd_namespace
  ci = var.cntk_ci
  create_operator_group = var.cntk_create_operator_group
  git_credentials = module.gitops-repo.git_credentials
  gitops_config = module.gitops-repo.gitops_config
  name = var.cntk_name
  server_name = module.gitops-repo.server_name
}
module "cos" {
  source = "cloud-native-toolkit/object-storage/ibm"
  version = "4.0.2"

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
  version = "3.2.2"

  provision = var.cs_resource_group_provision
  resource_group_name = var.cs_resource_group_name
  sync = var.cs_resource_group_sync
}
module "egress-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.1"

  _count = var.egress-subnets__count
  acl_rules = var.egress-subnets_acl_rules == null ? null : jsondecode(var.egress-subnets_acl_rules)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.egress-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.egress-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.egress-subnets_ipv4_cidr_blocks)
  label = var.egress-subnets_label
  provision = var.egress-subnets_provision
  region = var.region
  resource_group_name = module.resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.egress-subnets_zone_offset
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
  kms_key_crn = module.kms-key.crn
  label = var.flow_log_bucket_label
  metrics_monitoring_crn = module.sysdig.crn
  name = var.flow_log_bucket_name
  name_prefix = var.vpc_name_prefix
  provision = var.flow_log_bucket_provision
  region = var.region
  resource_group_name = module.resource_group.name
  storage_class = var.flow_log_bucket_storage_class
  suffix = var.suffix
  vpc_ip_addresses = module.ibm-vpc.addresses
}
module "gitops-cluster-config" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cluster-config?ref=v1.0.0"

  banner_background_color = var.gitops-cluster-config_banner_background_color
  banner_text = var.gitops-cluster-config_banner_text
  banner_text_color = var.gitops-cluster-config_banner_text_color
  git_credentials = module.gitops-repo.git_credentials
  gitops_config = module.gitops-repo.gitops_config
  namespace = module.cntk.name
  server_name = module.gitops-repo.server_name
}
module "gitops-console-link-job" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-console-link-job?ref=v1.4.5"

  git_credentials = module.gitops-repo.git_credentials
  gitops_config = module.gitops-repo.gitops_config
  namespace = module.cntk.name
  server_name = module.gitops-repo.server_name
}
module "gitops-repo" {
  source = "github.com/cloud-native-toolkit/terraform-tools-gitops?ref=v1.15.1"

  branch = var.gitops-repo_branch
  gitops_namespace = var.gitops-repo_gitops_namespace
  host = var.gitops-repo_host
  initialize = var.gitops-repo_initialize
  org = var.gitops-repo_org
  provision = var.gitops-repo_provision
  public = var.gitops-repo_public
  repo = var.gitops-repo_repo
  sealed_secrets_cert = module.sealed-secret-cert.cert
  server_name = var.gitops-repo_server_name
  strict = var.gitops-repo_strict
  token = var.gitops-repo_token
  type = var.gitops-repo_type
  username = var.gitops-repo_username
}
module "ibm-access-group" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-access-group?ref=v3.0.0"

  provision = module.resource_group.provision
  resource_group_name = module.resource_group.name
}
module "ibm-activity-tracker" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-activity-tracker?ref=v2.4.0"

  plan = var.ibm-activity-tracker_plan
  provision = var.ibm-activity-tracker_provision
  resource_group_name = module.at_resource_group.name
  resource_location = var.region
  tags = var.ibm-activity-tracker_tags == null ? null : jsondecode(var.ibm-activity-tracker_tags)
}
module "ibm-cert-manager" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-cert-manager?ref=v1.1.0"

  kms_enabled = var.ibm-cert-manager_kms_enabled
  kms_id = module.kms-key.kms_id
  kms_key_crn = module.kms-key.crn
  kms_private_endpoint = var.ibm-cert-manager_kms_private_endpoint
  kms_private_url = module.kms-key.kms_private_url
  kms_public_url = module.kms-key.kms_public_url
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
  resource_group_id = module.resource_group.id
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
  resource_group_name = module.resource_group.name
}
module "ibm-vpc-gateways" {
  source = "cloud-native-toolkit/vpc-gateways/ibm"
  version = "1.8.1"

  provision = var.ibm-vpc-gateways_provision
  region = var.region
  resource_group_id = module.resource_group.id
  vpc_name = module.ibm-vpc.name
}
module "ibm-vpc-vpn-gateway" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-vpn-gateway?ref=v1.1.2"

  ibmcloud_api_key = var.ibmcloud_api_key
  label = var.ibm-vpc-vpn-gateway_label
  mode = var.ibm-vpc-vpn-gateway_mode
  provision = var.ibm-vpc-vpn-gateway_provision
  region = var.region
  resource_group_id = module.resource_group.id
  tags = var.ibm-vpc-vpn-gateway_tags == null ? null : jsondecode(var.ibm-vpc-vpn-gateway_tags)
  vpc_name = module.ingress-subnets.vpc_name
  vpc_subnet_count = module.ingress-subnets.count
  vpc_subnets = module.ingress-subnets.subnets
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
  resource_group_name = module.resource_group.name
  resource_label = var.ibm-vpn-server_resource_label
  subnet_ids = module.ingress-subnets.ids
  vpc_id = module.ingress-subnets.vpc_id
  vpn_client_timeout = var.ibm-vpn-server_vpn_client_timeout
  vpn_server_port = var.ibm-vpn-server_vpn_server_port
  vpn_server_proto = var.ibm-vpn-server_vpn_server_proto
  vpnclient_ip = var.ibm-vpn-server_vpnclient_ip
}
module "ingress-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.1"

  _count = var.ingress-subnets__count
  acl_rules = var.ingress-subnets_acl_rules == null ? null : jsondecode(var.ingress-subnets_acl_rules)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.ingress-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.ingress-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.ingress-subnets_ipv4_cidr_blocks)
  label = var.ingress-subnets_label
  provision = var.ingress-subnets_provision
  region = var.region
  resource_group_name = module.resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.ingress-subnets_zone_offset
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
  version = "3.2.2"

  provision = var.kms_resource_group_provision
  resource_group_name = var.kms_resource_group_name
  sync = var.kms_resource_group_sync
}
module "kms-key" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-kms-key?ref=v1.5.1"

  dual_auth_delete = var.kms-key_dual_auth_delete
  force_delete = var.kms-key_force_delete
  kms_id = module.kms.guid
  kms_private_url = module.kms.private_url
  kms_public_url = module.kms.public_url
  label = var.kms-key_label
  name = var.kms-key_name
  name_prefix = var.vpc_name_prefix
  provision = var.kms-key_provision
  rotation_interval = var.kms-key_rotation_interval
}
module "olm" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-olm?ref=v1.3.2"

  cluster_config_file = module.cluster.config_file_path
  cluster_type = module.cluster.platform.type_code
  cluster_version = module.cluster.platform.version
}
module "resource_group" {
  source = "cloud-native-toolkit/resource-group/ibm"
  version = "3.2.2"

  provision = var.vpc_resource_group_provision
  resource_group_name = var.vpc_resource_group_name
  sync = var.resource_group_sync
}
module "sealed-secret-cert" {
  source = "github.com/cloud-native-toolkit/terraform-util-sealed-secret-cert?ref=v1.0.0"

  cert = var.sealed-secret-cert_cert
  cert_file = var.sealed-secret-cert_cert_file
  private_key = var.sealed-secret-cert_private_key
  private_key_file = var.sealed-secret-cert_private_key_file
}
module "sysdig" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-sysdig?ref=v4.0.1"

  label = var.sysdig_label
  name = var.sysdig_name
  name_prefix = var.cs_name_prefix
  plan = var.sysdig_plan
  provision = var.sysdig_provision
  region = var.region
  resource_group_name = module.cs_resource_group.name
  tags = var.sysdig_tags == null ? null : jsondecode(var.sysdig_tags)
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
  resource_group_name = module.resource_group.name
  rsa_bits = var.vpc_ssh_bastion_rsa_bits
}
module "vpe-cos" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-vpe-gateway?ref=v1.6.0"

  ibmcloud_api_key = var.ibmcloud_api_key
  name_prefix = var.vpc_name_prefix
  region = var.region
  resource_crn = module.cos.crn
  resource_group_name = module.resource_group.name
  resource_label = module.cos.label
  resource_service = module.cos.service
  sync = var.vpe-cos_sync
  vpc_id = module.vpe-subnets.vpc_id
  vpc_subnet_count = module.vpe-subnets.count
  vpc_subnets = module.vpe-subnets.subnets
}
module "vpe-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.1"

  _count = var.vpe-subnets__count
  acl_rules = var.vpe-subnets_acl_rules == null ? null : jsondecode(var.vpe-subnets_acl_rules)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.vpe-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.vpe-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.vpe-subnets_ipv4_cidr_blocks)
  label = var.vpe-subnets_label
  provision = var.vpe-subnets_provision
  region = var.region
  resource_group_name = module.resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.vpe-subnets_zone_offset
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
  kms_key_crn = module.kms-key.crn
  label = var.vsi-bastion_label
  profile_name = var.vsi-bastion_profile_name
  region = var.region
  resource_group_id = module.resource_group.id
  ssh_key_id = module.vpc_ssh_bastion.id
  tags = var.vsi-bastion_tags == null ? null : jsondecode(var.vsi-bastion_tags)
  target_network_range = var.vsi-bastion_target_network_range
  vpc_name = module.ibm-vpc.name
  vpc_subnet_count = module.bastion-subnets.count
  vpc_subnets = module.bastion-subnets.subnets
}
module "worker-subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.1"

  _count = var.mgmt_worker_subnet_count
  acl_rules = var.worker-subnets_acl_rules == null ? null : jsondecode(var.worker-subnets_acl_rules)
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.worker-subnets_ipv4_address_count
  ipv4_cidr_blocks = var.worker-subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.worker-subnets_ipv4_cidr_blocks)
  label = var.worker-subnets_label
  provision = var.worker-subnets_provision
  region = var.region
  resource_group_name = module.resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.worker-subnets_zone_offset
}
