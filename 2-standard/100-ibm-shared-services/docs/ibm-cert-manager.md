# IBM Certificate Manager module

Module to provision or lookup an instance of Certificate Manager on IBM Cloud. Optionally, the Certificate Manager instance can be encrypted with a root key from a KMS instance.

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v13

### Terraform providers

- IBM Cloud provider >= 1.22.0

## Module dependencies

This module makes use of the output from other modules:

- Resource Group - github.com/cloud-native-toolkit/terraform-ibm-resource-group
- KMS Key - github.com/cloud-native-toolkit/terraform-ibm-kms-key

## Example usage

[Refer test cases for more details](test/stages/stage2-cert-manager.tf)

```hcl-terraform
terraform {
  required_providers {
    ibm = {
      source = "ibm-cloud/ibm"
    }
  }
  required_version = ">= 0.13"
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region = var.region
}

module "cert-manager" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-cert-manager"

  resource_group_name = module.resource_group.name
  region = var.region
  provision = var.cert-manager_provision
  private_endpoint = var.cert-manager_private_endpoint
  kms_private_endpoint = var.cert-manager_kms_private_endpoint
  kms_enabled = var.cert-manager_kms_enabled
  kms_id      = module.kms_key.kms_id
  kms_key_crn = module.kms_key.crn
  kms_private_url = module.kms_key.kms_private_url
  kms_public_url  = module.kms_key.kms_public_url
  ibmcloud_api_key = var.ibmcloud_api_key
}
```

