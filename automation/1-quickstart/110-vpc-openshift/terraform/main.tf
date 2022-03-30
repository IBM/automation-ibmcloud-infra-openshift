module "argocd-bootstrap" {
  source = "github.com/cloud-native-toolkit/terraform-tools-argocd-bootstrap?ref=v1.6.1"

  bootstrap_path = module.gitops_repo.bootstrap_path
  bootstrap_prefix = var.argocd-bootstrap_bootstrap_prefix
  cluster_config_file = module.cluster.config_file_path
  cluster_type = module.cluster.platform.type_code
  create_webhook = var.argocd-bootstrap_create_webhook
  git_token = module.gitops_repo.config_token
  git_username = module.gitops_repo.config_username
  gitops_repo_url = module.gitops_repo.config_repo_url
  ingress_subdomain = module.cluster.platform.ingress
  olm_namespace = module.olm.olm_namespace
  operator_namespace = module.olm.target_namespace
  sealed_secret_cert = module.sealed-secret-cert.cert
  sealed_secret_private_key = module.sealed-secret-cert.private_key
}
module "cluster" {
  source = "cloud-native-toolkit/ocp-vpc/ibm"
  version = "1.13.1"

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
  gateways = module.ibm-vpc-gateways.gateways
  ipv4_address_count = var.cluster_subnets_ipv4_address_count
  ipv4_cidr_blocks = var.cluster_subnets_ipv4_cidr_blocks == null ? null : jsondecode(var.cluster_subnets_ipv4_cidr_blocks)
  label = var.cluster_subnets_label
  provision = var.cluster_subnets_provision
  region = var.region
  resource_group_name = module.resource_group.name
  vpc_name = module.ibm-vpc.name
  zone_offset = var.cluster_subnets_zone_offset
}
module "cos" {
  source = "cloud-native-toolkit/object-storage/ibm"
  version = "4.0.3"

  label = var.cos_label
  name_prefix = var.name_prefix
  plan = var.cos_plan
  provision = var.cos_provision
  resource_group_name = module.resource_group.name
  resource_location = var.cos_resource_location
  tags = var.cos_tags == null ? null : jsondecode(var.cos_tags)
}
module "gitops_repo" {
  source = "github.com/cloud-native-toolkit/terraform-tools-gitops?ref=v1.15.2"

  branch = var.gitops_repo_branch
  gitops_namespace = var.gitops_repo_gitops_namespace
  host = var.gitops_repo_host
  initialize = var.gitops_repo_initialize
  org = var.gitops_repo_org
  provision = var.gitops_repo_provision
  public = var.gitops_repo_public
  repo = var.gitops_repo_repo
  sealed_secrets_cert = module.sealed-secret-cert.cert
  server_name = var.gitops_repo_server_name
  strict = var.gitops_repo_strict
  token = var.gitops_repo_token
  type = var.gitops_repo_type
  username = var.gitops_repo_username
}
module "gitops-cluster-config" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cluster-config?ref=v1.0.0"

  banner_background_color = var.gitops-cluster-config_banner_background_color
  banner_text = var.gitops-cluster-config_banner_text
  banner_text_color = var.gitops-cluster-config_banner_text_color
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  namespace = module.toolkit.name
  server_name = module.gitops_repo.server_name
}
module "gitops-console-link-job" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-console-link-job?ref=v1.4.5"

  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  namespace = module.toolkit.name
  server_name = module.gitops_repo.server_name
}
module "ibm-access-group" {
  source = "cloud-native-toolkit/access-group/ibm"
  version = "3.0.2"

  provision = module.resource_group.provision
  resource_group_name = module.resource_group.name
}
module "ibm-logdna-bind" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-log-analysis-bind?ref=v1.3.1"

  cluster_id = module.cluster.id
  cluster_name = module.cluster.name
  ibmcloud_api_key = var.ibmcloud_api_key
  logdna_id = module.logdna.guid
  private_endpoint = var.private_endpoint
  region = var.region
  resource_group_name = module.resource_group.name
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
  name_prefix = var.name_prefix
  provision = var.ibm-vpc_provision
  region = var.region
  resource_group_name = module.resource_group.name
}
module "ibm-vpc-gateways" {
  source = "cloud-native-toolkit/vpc-gateways/ibm"
  version = "1.8.2"

  provision = var.ibm-vpc-gateways_provision
  region = var.region
  resource_group_id = module.resource_group.id
  vpc_name = module.ibm-vpc.name
}
module "logdna" {
  source = "cloud-native-toolkit/log-analysis/ibm"
  version = "4.1.2"

  label = var.logdna_label
  name = var.logdna_name
  name_prefix = var.name_prefix
  plan = var.logdna_plan
  provision = var.logdna_provision
  region = var.region
  resource_group_name = module.resource_group.name
  tags = var.logdna_tags == null ? null : jsondecode(var.logdna_tags)
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

  provision = var.resource_group_provision
  resource_group_name = var.resource_group_name
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
  source = "cloud-native-toolkit/cloud-monitoring/ibm"
  version = "4.1.2"

  label = var.sysdig_label
  name = var.sysdig_name
  name_prefix = var.name_prefix
  plan = var.sysdig_plan
  provision = var.sysdig_provision
  region = var.region
  resource_group_name = module.resource_group.name
  tags = var.sysdig_tags == null ? null : jsondecode(var.sysdig_tags)
}
module "sysdig-bind" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-cloud-monitoring-bind?ref=v1.3.1"

  access_key = module.sysdig.access_key
  cluster_id = module.cluster.id
  cluster_name = module.cluster.name
  guid = module.sysdig.guid
  ibmcloud_api_key = var.ibmcloud_api_key
  namespace = var.sysdig-bind_namespace
  private_endpoint = var.private_endpoint
  region = var.region
  resource_group_name = module.resource_group.name
  sync = var.sysdig-bind_sync
}
module "toolkit" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-namespace?ref=v1.11.1"

  argocd_namespace = var.toolkit_argocd_namespace
  ci = var.toolkit_ci
  create_operator_group = var.toolkit_create_operator_group
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  name = var.toolkit_name
  server_name = module.gitops_repo.server_name
}
