# IBM Cloud Quick Start Reference Architecture

Automation to provision the Quick Start reference architecture on IBM Cloud. This architecture implements the minimum infrastructure required to stand up a managed Red Hat OpenShift cluster with public endpoints.

## Reference Architecture

![QuickStart](architecture.png)

The automation is delivered in a number of layers that are applied in order. Layer `110` provisions the infrastructure including the Red Hat OpenShift cluster and the remaining layers provide configuration inside the cluster. Each layer depends on resources provided in the layer before it (e.g. `200` depends on `110`). Where two layers have the same numbers (e.g. `205`), you have a choice of which layer to apply.

### 110 - VPC OpenShift

This layer provisions the bulk of the IBM Cloud infrastructure. The following cloud resources are provisioned:

#### Network

- VPC network
- VPC Subnet
- VPC Public Gateways
- Red Hat OpenShift cluster

#### Shared Services

- Object Storage
- IBM Log Analysis
- IBM Cloud Monitoring

### 200 - ArgoCD Bootstrap

#### Software

- OpenShift GitOps (ArgoCD)
- OpenShift Pipelines (Tekton)
- Sealed Secrets (Kubeseal)
- GitOps repo

### 205 - Storage

The storage layer offers two options: `odf` and `portworx`. Either odf or portworx storage can be installed (or in rare instances, both).

#### ODF

- ODF operator
- ODF storage classes

#### Portworx

- IBM Cloud storage volumes
- Portworx operator
- Portworx storage classes

### 220 - Dev Tools

The dev tools layer installs standard continuous integration (CI) pipelines that integrate with tools that support the software development lifecycle. 

#### Software

- Artifactory
- Developer Dashboard
- Pact Broker
- Sonarqube
- Tekton Resources

## Automation

### Prerequisites

1. Have access to an IBM Cloud Account. An Enterprise account is best for workload isolation but this terraform can be run in a Pay Go account as well.

2. (Optional) Install and start Colima to run the terraform tools in a local bootstrapped container image.

    ```shell
    brew install docker colima
    colima start
    ```

### Setup

1. Clone this repository to your local SRE laptop or into a secure terminal. Open a shell into the cloned directory.
2. Copy `credentials.template` to `credentials.properties`.
3. Provide your IBM Cloud API key as the value for the `TF_VAR_ibmcloud_api_key` variable in `credentials.properties` (**Note:** `*.properties` has been added to `.gitignore` to ensure that the file containing the apikey cannot be checked into Git.)
4. Run `./launch.sh`. This will start a container image with the prompt opened in the `/terraform` directory.
5. Create a working copy of the terraform by running `./setup-workspace.sh`. Select `1` to set up the workspace for Quick Start. The script makes a copy of the terraform in `/workspaces/current` and sets up an empty `terraform.tfvars` file.
6. Change the directory to the subdirectory for the layer (e.g. `/workspaces/current`).

### Running each layer of automation sequentially

#### Configuration values

Configuration values need to be provided to terraform when the script is run. If not provided in advance, the terraform cli will prompt for them. However to ensure the automation is applied consistently at each layer, we highly recommend providing the values in a configuration file up front.

1. Uncomment and provide a value for each of the variables in `/workspaces/current/terraform.tfvars`. The `/workspaces/current/terraform.tfvars` file is shared between different terraform layers via a soft link so the values only need to be provided in one place.
2. At a minimum, the following values should be provided:

| Variable               | Description                                                            |
|------------------------|------------------------------------------------------------------------|
| resource_group_name    | The name of the resource group where the resources will be provisioned |
| region                 | The region where the resources will be provisioned                     |
| cluster_subnets__count | The number of subnets to provision for the cluster                     |
| worker_count           | The number of worker nodes that should be provisioned in each subnet   |
| cluster_flavor         | The machine type that will be used for the cluster                     |
| cluster_name           | The name of the cluster                                                |
| name_prefix            | The prefix for the cluster name                                        |
| config_banner_text     | The text to add in the top banner in the cluster                       |
| gitops_repo_host       | The host of the gitops repo (e.g. github.com)                          |
| gitops_repo_type       | The type of the gitops repo (e.g. github)                              |
| gitops_repo_org        | The existing org/group where the gitops repo will be created/found     |
| gitops_repo_repo       | The name for the gitops repo                                           |
| gitops_repo_username   | The username that will be used to access the gitops repo               |
| odf_namespace_name     | The namespace where the odf resource should be deployed                |

#### 110 - VPC OpenShift

1. Change the directory to `110-vpc-openshift/terraform`
2. Run the terraform:

    ```shell
    terraform init
    terraform apply -auto-approve
    ```

This layer makes use of the following variables:

| Variable               | Description                                                            |
|------------------------|------------------------------------------------------------------------|
| resource_group_name    | The name of the resource group where the resources will be provisioned |
| region                 | The region where the resources will be provisioned                     |
| cluster_subnets__count | The number of subnets to provision for the cluster                     |
| worker_count           | The number of worker nodes that should be provisioned in each subnet   |
| cluster_flavor         | The machine type that will be used for the cluster                     |
| cluster_name           | The name of the cluster                                                |
| name_prefix            | The prefix for the cluster name                                        |

#### 200 - ArgoCD Bootstrap

1. Change the directory to `200-argocd-bootstrap/terraform`
2. Run the terraform:

    ```shell
    terraform init
    terraform apply -auto-approve
    ```

This layer makes use of the following variables:

| Variable               | Description                                                            |
|------------------------|------------------------------------------------------------------------|
| resource_group_name    | The name of the resource group where the resources will be provisioned |
| region                 | The region where the resources will be provisioned                     |
| cluster_name           | The name of the cluster                                                |
| name_prefix            | The prefix for the cluster name                                        |
| config_banner_text     | The text to add in the top banner in the cluster                       |
| gitops_repo_host       | The host of the gitops repo (e.g. github.com)                          |
| gitops_repo_type       | The type of the gitops repo (e.g. github)                              |
| gitops_repo_org        | The existing org/group where the gitops repo will be created/found     |
| gitops_repo_repo       | The name for the gitops repo                                           |
| gitops_repo_username   | The username that will be used to access the gitops repo               |

#### 205 - Storage

Most of the IBM Cloud Pak software components have a special storage requirements and need a storage manager installed in the cluster. The Quick Start currently provides two options: **ODF storage** and **Portworx storage**. Each has different characteristics so pick the one that works best for your deployment. If you don't plan to install IBM Cloud Paks at this time you can skip this layer and apply it later when/if the need arises.

##### 205 - ODF Storage

1. Change the directory to `205-odf-storage/terraform`
2. Run the terraform:

    ```shell
    terraform init
    terraform apply -auto-approve
    ```

This layer makes use of the following variables:

| Variable               | Description                                                            |
|------------------------|------------------------------------------------------------------------|
| region                 | The region where the resources will be provisioned                     |
| cluster_name           | The name of the cluster                                                |
| odf_namespace_name     | The namespace where the odf resource should be deployed                |
| gitops_repo_host       | The host of the gitops repo (e.g. github.com)                          |
| gitops_repo_type       | The type of the gitops repo (e.g. github)                              |
| gitops_repo_org        | The existing org/group where the gitops repo will be created/found     |
| gitops_repo_repo       | The name for the gitops repo                                           |
| gitops_repo_username   | The username that will be used to access the gitops repo               |

##### 205 - Portworx Storage

1. Change the directory to `205-portworx-storage/terraform`
2. Run the terraform:

    ```shell
    terraform init
    terraform apply -auto-approve
    ```

This layer makes use of the following variables:

| Variable               | Description                                                        |
|------------------------|--------------------------------------------------------------------|
| region                 | The region where the resources will be provisioned                 |
| cluster_name           | The name of the cluster                                            |
| resource_group_name    | The name of the resource group                                     |

#### 220 - Dev tools

1. Change the directory to `220-dev-tools/terrform`
2. Run the terraform:

    ```shell
    terraform init
    terraform apply -auto-approve
    ```

This layer makes use of the following variables:

| Variable             | Description                                                        |
|----------------------|--------------------------------------------------------------------|
| gitops_repo_host     | The host of the gitops repo (e.g. github.com)                      |
| gitops_repo_type     | The type of the gitops repo (e.g. github)                          |
| gitops_repo_org      | The existing org/group where the gitops repo will be created/found |
| gitops_repo_repo     | The name for the gitops repo                                       |
| gitops_repo_username | The username that will be used to access the gitops repo           |
