# Pact Broker gitops module

Module to populate a gitops repo with the Pact Broker deployment.

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform >= v0.15
- kubectl

### Terraform providers

- None

## Module dependencies 

This module makes use of the output from other modules:

- Cluster - github.com/ibm-garage-cloud/terraform-ibm-container-platform.git
- Namespace - github.com/ibm-garage-clout/terraform-cluster-namespace.git
- etc
## Example usage

```hcl-terraform
module "gitops_pactbroker" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-pactbroker.git"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  namespace = module.gitops_namespace.name
  server_name = module.gitops.server_name
}
```

