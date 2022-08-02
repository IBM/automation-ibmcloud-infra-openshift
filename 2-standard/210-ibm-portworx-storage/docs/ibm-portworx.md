# Starter kit for a Terraform module

This is a Terraform module to install Portworx, a cloud-native persistent storage and data management solution for Kubernetes and OpenShift clusters, into a VPC cluster on IBM Cloud.

This module will:

1. Create a storage volume for each worker in the cluster
2. Mount each volume to the workers
3. Optionally create a managed etcd database instance for Portworx to use
4. Install Portworx into the cluster
5. Create StorageClass instances within the cluster to allow use of Portworx encrypted volumes

This module is derivative from the Portworx template at https://github.com/ibm-hcbt/terraform-ibm-cloud-pak/tree/main/modules/portworx
It also leverages additional scripts from https://github.com/IBM/ibmcloud-storage-utilities/tree/master/px-utils

Changes include:

- Compatibility with the modular approach used by [Cloud Native Toolkit Terraform modules](https://github.com/cloud-native-toolkit)
- Support for the `terraform destroy` command. It will now completly remove Portworx and the associated volumes from the cluster
- Suppport for dynamic volume creation based on VPC cluster workers

Additional documentation on Portworx on IBM Cloud available at:

- https://docs.portworx.com/portworx-install-with-kubernetes/cloud/ibm/
- https://cloud.ibm.com/docs/containers?topic=containers-portworx

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v15
- kubectl

### Terraform providers

- IBM Cloud provider >= 1.22.0

## Module dependencies

This module makes use of the output from other modules:

- Cluster - https://github.com/ibm-garage-cloud/terraform-ibm-container-platform
- Resource Group - https://github.com/cloud-native-toolkit/terraform-ibm-resource-group

## Example usage

```hcl-terraform
module "portworx_module" {
  source = "github.com/cloud-native-toolkit/terraform-portworx.git"
  resource_group_name = var.resource_group_name
  region              = var.region
  ibmcloud_api_key    = var.ibmcloud_api_key
  cluster_name        = module.cluster.name
  name_prefix         = var.name_prefix
  workers             = module.cluster.workers
  worker_count        = module.cluster.total_worker_count
  create_external_etcd = var.create_external_etcds
}

```
