# Tekton Resources GitOps module

Module to populate a gitops repo with Tekton resources (tasks and pipelines).

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform >= v0.15

### Terraform providers

- None

## Module dependencies

This module makes use of the output from other modules:

- GitOps repo - github.com/cloud-native-toolkit/terraform-tools-gitops.git
- Namespace - github.com/cloud-native-toolkit/terraform-gitops-namespace.git

## Example usage

```hcl-terraform
module "tekton_resources" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-tekton-resources"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  namespace = module.gitops_namespace.name
}
```

