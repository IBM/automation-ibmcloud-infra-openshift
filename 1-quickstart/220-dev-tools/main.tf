module "gitops_repo" {
  source = "github.com/cloud-native-toolkit/terraform-tools-gitops?ref=v1.22.2"

  branch = var.gitops_repo_branch
  debug = var.debug
  gitea_host = var.gitops_repo_gitea_host
  gitea_org = var.gitops_repo_gitea_org
  gitea_token = var.gitops_repo_gitea_token
  gitea_username = var.gitops_repo_gitea_username
  gitops_namespace = var.gitops_repo_gitops_namespace
  host = var.gitops_repo_host
  org = var.gitops_repo_org
  project = var.gitops_repo_project
  public = var.gitops_repo_public
  repo = var.gitops_repo_repo
  sealed_secrets_cert = var.gitops_repo_sealed_secrets_cert
  server_name = var.gitops_repo_server_name
  strict = var.gitops_repo_strict
  token = var.gitops_repo_token
  type = var.gitops_repo_type
  username = var.gitops_repo_username
}
module "gitops-artifactory" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-artifactory?ref=v1.3.0"

  cluster_ingress_hostname = var.gitops-artifactory_cluster_ingress_hostname
  cluster_type = var.gitops-artifactory_cluster_type
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  namespace = module.tools_namespace.name
  persistence = var.gitops-artifactory_persistence
  server_name = module.gitops_repo.server_name
  storage_class = var.gitops-artifactory_storage_class
  tls_secret_name = var.gitops-artifactory_tls_secret_name
}
module "gitops-buildah-unprivileged" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-buildah-unprivileged?ref=v1.1.1"

  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  namespace = module.tools_namespace.name
  server_name = module.gitops_repo.server_name
}
module "gitops-dashboard" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-dashboard?ref=v1.7.0"

  cluster_ingress_hostname = var.gitops-dashboard_cluster_ingress_hostname
  cluster_type = var.gitops-dashboard_cluster_type
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  image_tag = var.gitops-dashboard_image_tag
  namespace = module.tools_namespace.name
  server_name = module.gitops_repo.server_name
  tls_secret_name = var.gitops-dashboard_tls_secret_name
}
module "gitops-pact-broker" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-pact-broker?ref=v1.2.0"

  cluster_ingress_hostname = var.gitops-pact-broker_cluster_ingress_hostname
  cluster_type = var.gitops-pact-broker_cluster_type
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  namespace = module.tools_namespace.name
  server_name = module.gitops_repo.server_name
  tls_secret_name = var.gitops-pact-broker_tls_secret_name
}
module "gitops-sonarqube" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-sonarqube?ref=v1.3.0"

  cluster_ingress_hostname = var.gitops-sonarqube_cluster_ingress_hostname
  cluster_type = var.gitops-sonarqube_cluster_type
  cluster_version = var.gitops-sonarqube_cluster_version
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  hostname = var.gitops-sonarqube_hostname
  kubeseal_cert = module.gitops_repo.sealed_secrets_cert
  namespace = module.tools_namespace.name
  persistence = var.gitops-sonarqube_persistence
  plugins = var.gitops-sonarqube_plugins == null ? null : jsondecode(var.gitops-sonarqube_plugins)
  server_name = module.gitops_repo.server_name
  service_account_name = var.gitops-sonarqube_service_account_name
  storage_class = var.gitops-sonarqube_storage_class
  tls_secret_name = var.gitops-sonarqube_tls_secret_name
}
module "gitops-swagger-editor" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-swagger-editor?ref=v0.1.0"

  cluster_ingress_hostname = var.gitops-swagger-editor_cluster_ingress_hostname
  cluster_type = var.gitops-swagger-editor_cluster_type
  enable_sso = var.gitops-swagger-editor_enable_sso
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  kubeseal_cert = module.gitops_repo.sealed_secrets_cert
  namespace = module.tools_namespace.name
  server_name = module.gitops_repo.server_name
  tls_secret_name = var.gitops-swagger-editor_tls_secret_name
}
module "gitops-tekton-resources" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-tekton-resources?ref=v2.1.0"

  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  namespace = module.tools_namespace.name
  server_name = module.gitops_repo.server_name
  task_release = var.gitops-tekton-resources_task_release
}
module "tools_namespace" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-namespace?ref=v1.12.2"

  argocd_namespace = var.tools_namespace_argocd_namespace
  ci = var.tools_namespace_ci
  create_operator_group = var.tools_namespace_create_operator_group
  git_credentials = module.gitops_repo.git_credentials
  gitops_config = module.gitops_repo.gitops_config
  name = var.tools_namespace_name
  server_name = module.gitops_repo.server_name
}
module "util-clis" {
  source = "cloud-native-toolkit/clis/util"
  version = "1.18.1"

  bin_dir = var.util-clis_bin_dir
  clis = var.util-clis_clis == null ? null : jsondecode(var.util-clis_clis)
}
