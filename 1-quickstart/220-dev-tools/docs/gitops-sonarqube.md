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
module "dev_tools_argocd" {
  source = "github.com/ibm-garage-cloud/terraform-tools-argocd.git?ref=v1.0.0"

  cluster_config_file = module.dev_cluster.config_file_path
  cluster_type        = module.dev_cluster.type
  app_namespace       = module.dev_cluster_namespaces.tools_namespace_name
  ingress_subdomain   = module.dev_cluster.ingress_hostname
  olm_namespace       = module.dev_software_olm.olm_namespace
  operator_namespace  = module.dev_software_olm.target_namespace
  name                = "argocd"
}
```

