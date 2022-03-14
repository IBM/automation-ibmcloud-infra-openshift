module "gitops-artifactory" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-artifactory?ref=v1.2.0"

  cluster_ingress_hostname = var.gitops-artifactory_cluster_ingress_hostname
  cluster_type = var.gitops-artifactory_cluster_type
  git_credentials = module.gitops-repo.git_credentials
  gitops_config = module.gitops-repo.gitops_config
  namespace = module.namespace.name
  persistence = var.gitops-artifactory_persistence
  server_name = module.gitops-repo.server_name
  storage_class = var.gitops-artifactory_storage_class
  tls_secret_name = var.gitops-artifactory_tls_secret_name
}
module "gitops-dashboard" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-dashboard?ref=v1.6.1"

  cluster_ingress_hostname = var.gitops-dashboard_cluster_ingress_hostname
  cluster_type = var.gitops-dashboard_cluster_type
  git_credentials = module.gitops-repo.git_credentials
  gitops_config = module.gitops-repo.gitops_config
  image_tag = var.gitops-dashboard_image_tag
  namespace = module.namespace.name
  server_name = module.gitops-repo.server_name
  tls_secret_name = var.gitops-dashboard_tls_secret_name
}
module "gitops-pact-broker" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-pact-broker?ref=v1.1.3"

  cluster_ingress_hostname = var.gitops-pact-broker_cluster_ingress_hostname
  cluster_type = var.gitops-pact-broker_cluster_type
  git_credentials = module.gitops-repo.git_credentials
  gitops_config = module.gitops-repo.gitops_config
  namespace = module.namespace.name
  server_name = module.gitops-repo.server_name
  tls_secret_name = var.gitops-pact-broker_tls_secret_name
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
  sealed_secrets_cert = var.gitops-repo_sealed_secrets_cert
  server_name = var.gitops-repo_server_name
  strict = var.gitops-repo_strict
  token = var.gitops-repo_token
  type = var.gitops-repo_type
  username = var.gitops-repo_username
}
module "gitops-sonarqube" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-sonarqube?ref=v1.2.2"

  cluster_ingress_hostname = var.gitops-sonarqube_cluster_ingress_hostname
  cluster_type = var.gitops-sonarqube_cluster_type
  git_credentials = module.gitops-repo.git_credentials
  gitops_config = module.gitops-repo.gitops_config
  hostname = var.gitops-sonarqube_hostname
  kubeseal_cert = module.gitops-repo.sealed_secrets_cert
  namespace = module.namespace.name
  persistence = var.gitops-sonarqube_persistence
  plugins = var.gitops-sonarqube_plugins == null ? null : jsondecode(var.gitops-sonarqube_plugins)
  postgresql = var.gitops-sonarqube_postgresql
  server_name = module.gitops-repo.server_name
  service_account_name = var.gitops-sonarqube_service_account_name
  storage_class = var.gitops-sonarqube_storage_class
  tls_secret_name = var.gitops-sonarqube_tls_secret_name
}
module "gitops-tekton-resources" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-tekton-resources?ref=v1.1.3"

  git_credentials = module.gitops-repo.git_credentials
  gitops_config = module.gitops-repo.gitops_config
  namespace = module.namespace.name
  server_name = module.gitops-repo.server_name
  task_release = var.gitops-tekton-resources_task_release
}
module "namespace" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-namespace?ref=v1.11.1"

  argocd_namespace = var.namespace_argocd_namespace
  ci = var.namespace_ci
  create_operator_group = var.namespace_create_operator_group
  git_credentials = module.gitops-repo.git_credentials
  gitops_config = module.gitops-repo.gitops_config
  name = var.namespace_name
  server_name = module.gitops-repo.server_name
}
