module "argocd-bootstrap" {
  source = "github.com/cloud-native-toolkit/terraform-tools-argocd-bootstrap?ref=v1.6.5"

  bootstrap_path = module.gitops_repo.bootstrap_path
  bootstrap_prefix = var.argocd-bootstrap_bootstrap_prefix
  cluster_config_file = module.integration_cluster.config_file_path
  cluster_type = module.integration_cluster.platform.type_code
  create_webhook = var.argocd-bootstrap_create_webhook
  git_token = module.gitops_repo.config_token
  git_username = module.gitops_repo.config_username
  gitops_repo_url = module.gitops_repo.config_repo_url
  ingress_subdomain = module.integration_cluster.platform.ingress
  olm_namespace = module.olm.olm_namespace
  operator_namespace = module.olm.target_namespace
  sealed_secret_cert = module.sealed-secret-cert.cert
  sealed_secret_private_key = module.sealed-secret-cert.private_key
}
module "gitops_repo" {
  source = "github.com/cloud-native-toolkit/terraform-tools-gitops?ref=v1.15.3"

  branch = var.gitops_repo_branch
  gitops_namespace = var.gitops_repo_gitops_namespace
  host = var.gitops_repo_host
  org = var.gitops_repo_org
  public = var.gitops_repo_public
  repo = var.gitops_repo_repo
  sealed_secrets_cert = module.sealed-secret-cert.cert
  server_name = var.gitops_repo_integration_server_name
  strict = var.gitops_repo_strict
  token = var.gitops_repo_token
  type = var.gitops_repo_type
  username = var.gitops_repo_username
}
module "gitops-console-link-job" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-console-link-job?ref=v1.4.5"

  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  namespace = module.toolkit_namespace.name
  server_name = module.gitops_repo.server_name
}
module "integration_cluster" {
  source = "cloud-native-toolkit/ocp-vpc/ibm"
  version = "1.13.2"

  cos_id = var.integration_cluster_cos_id
  disable_public_endpoint = var.integration_cluster_disable_public_endpoint
  exists = var.integration_cluster_exists
  flavor = var.integration_cluster_flavor
  force_delete_storage = var.integration_cluster_force_delete_storage
  ibmcloud_api_key = var.ibmcloud_api_key
  kms_enabled = var.integration_cluster_kms_enabled
  kms_id = var.integration_cluster_kms_id
  kms_key_id = var.integration_cluster_kms_key_id
  kms_private_endpoint = var.integration_cluster_kms_private_endpoint
  login = var.integration_cluster_login
  name = var.integration_cluster_name
  name_prefix = var.name_prefix
  ocp_entitlement = var.integration_cluster_ocp_entitlement
  ocp_version = var.ocp_version
  region = var.region
  resource_group_name = module.integration_resource_group.name
  sync = module.integration_resource_group.sync
  tags = var.integration_cluster_tags == null ? null : jsondecode(var.integration_cluster_tags)
  vpc_name = var.integration_cluster_vpc_name
  vpc_subnet_count = var.integration_cluster_vpc_subnet_count
  vpc_subnets = var.integration_cluster_vpc_subnets == null ? null : jsondecode(var.integration_cluster_vpc_subnets)
  worker_count = var.worker_count
}
module "integration_config" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cluster-config?ref=v1.0.0"

  banner_background_color = var.integration_config_banner_background_color
  banner_text = var.integration_config_banner_text
  banner_text_color = var.integration_config_banner_text_color
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  namespace = module.toolkit_namespace.name
  server_name = module.gitops_repo.server_name
}
module "integration_resource_group" {
  source = "cloud-native-toolkit/resource-group/ibm"
  version = "3.2.10"

  ibmcloud_api_key = var.ibmcloud_api_key
  resource_group_name = var.integration_resource_group_name
  sync = var.integration_resource_group_sync
}
module "olm" {
  source = "github.com/cloud-native-toolkit/terraform-k8s-olm?ref=v1.3.2"

  cluster_config_file = module.integration_cluster.config_file_path
  cluster_type = module.integration_cluster.platform.type_code
  cluster_version = module.integration_cluster.platform.version
}
module "sealed-secret-cert" {
  source = "github.com/cloud-native-toolkit/terraform-util-sealed-secret-cert?ref=v1.0.0"

  cert = var.sealed-secret-cert_cert
  cert_file = var.sealed-secret-cert_cert_file
  private_key = var.sealed-secret-cert_private_key
  private_key_file = var.sealed-secret-cert_private_key_file
}
module "toolkit_namespace" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-namespace?ref=v1.11.1"

  argocd_namespace = var.toolkit_namespace_argocd_namespace
  ci = var.toolkit_namespace_ci
  create_operator_group = var.toolkit_namespace_create_operator_group
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  name = var.toolkit_namespace_name
  server_name = module.gitops_repo.server_name
}
