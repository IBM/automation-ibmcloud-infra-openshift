variable "gitops-artifactory_cluster_type" {
  type = string
  description = "The cluster type (openshift or ocp3 or ocp4 or kubernetes)"
  default = "ocp4"
}
variable "gitops-artifactory_cluster_ingress_hostname" {
  type = string
  description = "Ingress hostname of the IKS cluster."
  default = ""
}
variable "gitops-artifactory_tls_secret_name" {
  type = string
  description = "The name of the secret containing the tls certificate values"
  default = ""
}
variable "gitops-artifactory_storage_class" {
  type = string
  description = "The storage class to use for the persistent volume claim"
  default = ""
}
variable "gitops-artifactory_persistence" {
  type = bool
  description = "Flag to indicate if persistence should be enabled"
  default = true
}
variable "gitops-dashboard_cluster_type" {
  type = string
  description = "The cluster type (openshift or ocp3 or ocp4 or kubernetes)"
  default = "ocp4"
}
variable "gitops-dashboard_cluster_ingress_hostname" {
  type = string
  description = "Ingress hostname of the IKS cluster."
  default = ""
}
variable "gitops-dashboard_tls_secret_name" {
  type = string
  description = "The name of the secret containing the tls certificate values"
  default = ""
}
variable "gitops-dashboard_image_tag" {
  type = string
  description = "The image version tag to use"
  default = "v1.4.4"
}
variable "namespace_name" {
  type = string
  description = "The value that should be used for the namespace"
  default = "tools"
}
variable "namespace_ci" {
  type = bool
  description = "Flag indicating that this namespace will be used for development (e.g. configmaps and secrets)"
  default = false
}
variable "namespace_create_operator_group" {
  type = bool
  description = "Flag indicating that an operator group should be created in the namespace"
  default = true
}
variable "namespace_argocd_namespace" {
  type = string
  description = "The namespace where argocd has been deployed"
  default = "openshift-gitops"
}
variable "gitops-pact-broker_cluster_type" {
  type = string
  description = "The cluster type (openshift or ocp3 or ocp4 or kubernetes)"
  default = "ocp4"
}
variable "gitops-pact-broker_cluster_ingress_hostname" {
  type = string
  description = "Ingress hostname of the IKS cluster."
  default = ""
}
variable "gitops-pact-broker_tls_secret_name" {
  type = string
  description = "The name of the secret containing the tls certificate values"
  default = ""
}
variable "gitops-repo_host" {
  type = string
  description = "The host for the git repository."
}
variable "gitops-repo_type" {
  type = string
  description = "The type of the hosted git repository (github or gitlab)."
}
variable "gitops-repo_org" {
  type = string
  description = "The org/group where the git repository exists/will be provisioned."
}
variable "gitops-repo_repo" {
  type = string
  description = "The short name of the repository (i.e. the part after the org/group name)"
}
variable "gitops-repo_branch" {
  type = string
  description = "The name of the branch that will be used. If the repo already exists (provision=false) then it is assumed this branch already exists as well"
  default = "main"
}
variable "gitops-repo_provision" {
  type = bool
  description = "Flag indicating that the git repo should be provisioned. If `false` then the repo is expected to already exist"
  default = true
}
variable "gitops-repo_initialize" {
  type = bool
  description = "Flag indicating that the git repo should be initialized. If `false` then the repo is expected to already have been initialized"
  default = false
}
variable "gitops-repo_username" {
  type = string
  description = "The username of the user with access to the repository"
}
variable "gitops-repo_token" {
  type = string
  description = "The personal access token used to access the repository"
}
variable "gitops-repo_public" {
  type = bool
  description = "Flag indicating that the repo should be public or private"
  default = false
}
variable "gitops-repo_gitops_namespace" {
  type = string
  description = "The namespace where ArgoCD is running in the cluster"
  default = "openshift-gitops"
}
variable "gitops-repo_server_name" {
  type = string
  description = "The name of the cluster that will be configured via gitops. This is used to separate the config by cluster"
  default = "default"
}
variable "gitops-repo_sealed_secrets_cert" {
  type = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default = ""
}
variable "gitops-repo_strict" {
  type = bool
  description = "Flag indicating that an error should be thrown if the repo already exists"
  default = false
}
variable "gitops-sonarqube_cluster_type" {
  type = string
  description = "The cluster type (openshift or ocp3 or ocp4 or kubernetes)"
  default = "ocp4"
}
variable "gitops-sonarqube_cluster_ingress_hostname" {
  type = string
  description = "Ingress hostname of the IKS cluster."
  default = ""
}
variable "gitops-sonarqube_tls_secret_name" {
  type = string
  description = "The name of the secret containing the tls certificate values"
  default = ""
}
variable "gitops-sonarqube_storage_class" {
  type = string
  description = "The storage class to use for the persistent volume claim"
  default = ""
}
variable "gitops-sonarqube_service_account_name" {
  type = string
  description = "The name of the service account that should be used for the deployment"
  default = "sonarqube-sonarqube"
}
variable "gitops-sonarqube_plugins" {
  type = string
  description = "The list of plugins that will be installed on SonarQube"
  default = "\"[ https://github.com/checkstyle/sonar-checkstyle/releases/download/4.33/checkstyle-sonar-plugin-4.33.jar ]\""
}
variable "gitops-sonarqube_postgresql" {
  type = string
  description = "Properties for an existing postgresql database"
  default = "\"{ username = password = hostname = port = database_name = external = false }\""
}
variable "gitops-sonarqube_hostname" {
  type = string
  description = "The hostname that will be used for the ingress/route"
  default = "sonarqube"
}
variable "gitops-sonarqube_persistence" {
  type = bool
  description = "Flag indicating that persistence should be enabled for the pods"
  default = false
}
variable "gitops-tekton-resources_task_release" {
  type = string
  description = "The release version of the tekton tasks"
  default = "v2.7.1"
}
