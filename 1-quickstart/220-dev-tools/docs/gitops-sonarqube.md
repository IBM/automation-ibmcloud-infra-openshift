# SonarQube gitops module

Module to populate a gitops repo with the resources to deploy SonarQube



## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform >= v0.15
- kubectl

### Terraform providers

- IBM Cloud provider >= 1.5.3
- Helm provider >= 1.1.1 (provided by Terraform)

## Module dependencies

This module makes use of the output from other modules:

- Cluster - github.com/ibm-garage-cloud/terraform-ibm-container-platform.git
- Namespace - github.com/ibm-garage-cloud/terraform-cluster-namespace.git
- etc.

## Example usage

```hcl-terraform
module "gitops_sonarqube" {
  source = "https://github.com/cloud-native-toolkit/terraform-gitops-sonarqube"

  gitops_config            = module.gitops.gitops_config
  git_credentials          = module.gitops.git_credentials
  namespace                = module.gitops_namespace.name
  kubeseal_cert            = module.gitops.sealed_secrets_cert
  server_name              = module.gitops.server_name
}
```

