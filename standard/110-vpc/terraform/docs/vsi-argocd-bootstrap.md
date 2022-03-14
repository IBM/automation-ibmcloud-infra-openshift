# VSI ArgoCD Bootstrap module

Module to provision the OpenShift CI/CD module (OpenShift GitOps, OpenShift Pipelines, and Sealed Secrets) and bootstrap it with a GitOps repo vai a VSI "jump server". This is particularly needed when the OpenShift cluster only exposes private endpoints and is behind a VPN.

Once this module has successfully been provisioned, changes to the cluster can be managed through the bootstrapped GitOps repo instead of directly connecting to the cluster.

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v13

### Terraform providers

- IBM Cloud provider >= 1.17

## Module dependencies

This module makes use of the output from other modules:

- Resource group - github.com/cloud-native-toolkit/terraform-ibm-resource-group.git
- Cluster - github.com/ibm-garage-cloud/terraform-ibm-container-platform.git
- OLM - github.com/ibm-garage-cloud/terraform-software-olm.git
- GitOps - github.com/cloud-native-toolkit/terraform-tools-gitops
- Subnets - github.com/cloud-native-toolkit/terraform-ibm-vpc-subnets.git
- Sealed Secret Certs - github.com/cloud-native-toolkit/terraform-util-sealed-secret-cert.git

## Example usage

```hcl-terraform
module "argocd_bootstrap" {
  source = "github.com/cloud-native-toolkit/terraform-vsi-argocd-bootstrap.git"

  ibmcloud_api_key    = var.ibmcloud_api_key
  region              = var.region
  resource_group_name = module.resource_group.name
  cluster_type        = module.dev_cluster.platform.type_code
  ingress_subdomain   = module.dev_cluster.platform.ingress
  olm_namespace       = module.dev_software_olm.olm_namespace
  operator_namespace  = module.dev_software_olm.target_namespace
  gitops_repo_url     = module.gitops.config_repo_url
  git_username        = module.gitops.config_username
  git_token           = module.gitops.config_token
  bootstrap_path      = module.gitops.bootstrap_path
  server_url          = module.dev_cluster.platform.server_url
  vpc_name            = module.subnets.vpc_name
  vpc_subnet_count    = module.subnets.count
  vpc_subnets         = module.subnets.subnets
  bootstrap_branch    = module.gitops.bootstrap_branch
  sealed_secret_cert  = module.cert.cert
  sealed_secret_private_key = module.cert.private_key
}
```
