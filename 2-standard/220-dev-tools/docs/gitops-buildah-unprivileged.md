# Buildah unprivileged gitops module 

Module to populate a gitops repo to set up a Red Hat OpenShift cluster to allow buildah to run unprivileged. (This is primarily necessary for IBM ROKS clusters.)

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform >= v0.15

### Terraform providers

None

## Module dependencies

This module makes use of the output from other modules:

- GitOps - github.com/cloud-native-toolkit/terraform-tools-gitops.git
- Namespace - github.com/cloud-native-toolkit/terraform-gitops-namespace.git

## Example usage

```hcl-terraform
module "buildah_unprivileged" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-buildah-unprivileged.git"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name
}
```

