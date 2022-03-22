module "argocd-bootstrap" {
  source = "github.com/cloud-native-toolkit/terraform-tools-argocd-bootstrap?ref=v1.6.0"

  bootstrap_path = module.gitops-repo.bootstrap_path
  bootstrap_prefix = var.argocd-bootstrap_bootstrap_prefix
  cluster_config_file = module.cluster.config_file_path
  cluster_type = module.cluster.platform.type_code
  create_webhook = var.argocd-bootstrap_create_webhook
  git_token = module.gitops-repo.config_token
  git_username = module.gitops-repo.config_username
  gitops_repo_url = module.gitops-repo.config_repo_url
  ingress_subdomain = module.cluster.platform.ingress
  olm_namespace = module.olm.olm_namespace
  operator_namespace = module.olm.target_namespace
  sealed_secret_cert = module.sealed-secret-cert.cert
  sealed_secret_private_key = module.sealed-secret-cert.private_key
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
  name_prefix = var.name_prefix
  ocp_entitlement = var.cluster_ocp_entitlement
  ocp_version = var.ocp_version
  region = var.region
  resource_group_name = module.resource_group.name
  sync = module.resource_group.sync
  vpc_name = module.cluster_subnets.vpc_name
  vpc_subnet_count = module.cluster_subnets.count
  vpc_subnets = module.cluster_subnets.subnets
  worker_count = var.worker_count
}
module "cluster_subnets" {
  source = "cloud-native-toolkit/vpc-subnets/ibm"
  version = "1.12.1"

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
  version = "4.0.2"

  label = var.cos_label
  name_prefix = var.name_prefix
  plan = var.cos_plan
  provision = var.cos_provision
  resource_group_name = module.resource_group.name
  resource_location = var.cos_resource_location
  tags = var.cos_tags == null ? null : jsondecode(var.cos_tags)
}
module "gitops-cluster-config" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cluster-config?ref=v1.0.0"

  banner_background_color = var.gitops-cluster-config_banner_background_color
  banner_text = var.gitops-cluster-config_banner_text
  banner_text_color = var.gitops-cluster-config_banner_text_color
  git_credentials = module.gitops-repo.git_credentials
  gitops_config = module.gitops-repo.gitops_config
  namespace = module.toolkit.name
  server_name = module.gitops-repo.server_name
}
module "gitops-console-link-job" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-console-link-job?ref=v1.4.5"

  git_credentials = module.gitops-repo.git_credentials
  gitops_config = module.gitops-repo.gitops_config
  namespace = module.toolkit.name
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
module "ibm-logdna-bind" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-logdna-bind?ref=v1.2.3"

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
  version = "1.8.1"

  provision = var.ibm-vpc-gateways_provision
  region = var.region
  resource_group_id = module.resource_group.id
  vpc_name = module.ibm-vpc.name
}
module "logdna" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-logdna?ref=v4.0.0"

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
  source = "github.com/cloud-native-toolkit/terraform-ibm-sysdig?ref=v4.0.1"

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
  source = "github.com/cloud-native-toolkit/terraform-ibm-sysdig-bind?ref=v1.2.3"

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
  git_credentials = module.gitops-repo.git_credentials
  gitops_config = module.gitops-repo.gitops_config
  name = var.toolkit_name
  server_name = module.gitops-repo.server_name
}
