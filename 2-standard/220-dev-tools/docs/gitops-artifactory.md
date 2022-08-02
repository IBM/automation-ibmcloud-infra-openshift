# Artifactory Gitops module

Module to populate a gitops repository with the resources to deploy Artifactory.

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v0.15
- git

### Terraform providers

- None

## Module dependencies

This module makes use of the output from other modules:

- GitOps - github.com/cloud-native-toolkit/terraform-tools-gitops.git
- Cluster - github.com/ibm-garage-cloud/terraform-ibm-ocp-vpc.git
- Namespace - github.com/cloud-native-toolkit/terraform-gitops-namespace.git


## Example usage

```hcl-terraform
module "gitops_artifactory" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-artifactory.git"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  namespace = module.gitops_namespace.name
  server_name = module.gitops.server_name
}
```

