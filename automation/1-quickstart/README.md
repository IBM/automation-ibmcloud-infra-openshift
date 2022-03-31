# IBM Cloud Quick Start Reference Architecture

Automation to provision the Quick Start reference architecture on IBM Cloud. The architecture implements the minimum infrastructure required to stand up a managed Red Hat OpenShift cluster with public endpoints.

## Reference Architecture

![QuickStart](architecture.png)

The automation is delivered in a number of layers that are applied in order. The layers above 110 are optional.

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

### Running each layer of automation sequentially

#### 110 - VPC OpenShift

1. Run `110-vpc-openshift/apply.sh`
2. The script will prompt for variables that must be provided for the script. Alternatively, the values can be provided in a file named `variables.yaml`. An example yaml file has been provided in `variables.template.yaml`.

| Variable               | Description                                                            |
|------------------------|------------------------------------------------------------------------|
| resource_group_name    | The name of the resource group where the resources will be provisioned |
| region                 | The region where the resources will be provisioned                     |
| cluster_subnets__count | The number of subnets to provision for the cluster                     |
| worker_count           | The number of worker nodes that should be provisioned in each subnet   |
| cluster_flavor         | The machine type that will be used for the cluster                     |
| cluster_name           | The name of the cluster                                                |
| name_prefix            | The prefix for the cluster name                                        |

3. When the script runs, all of the provided values will be written to ta file named `variables.yaml` and the terraform will be applied.

#### 200 - ArgoCD Bootstrap

1. Run `200-argocd-bootstrap/apply.sh`
2. The script will prompt for variables that must be provided for the script. Alternatively, the values can be provided in a file named `variables.yaml`. An example yaml file has been provided in `variables.template.yaml`.

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

#### 205 - ODF Storage

1. Run `205-odf-storage/apply.sh`
2. The script will prompt for variables that must be provided for the script. Alternatively, the values can be provided in a file named `variables.yaml`. An example yaml file has been provided in `variables.template.yaml`.

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

#### 205 - Portworx Storage

1. Run `205-portworx-storage/apply.sh`
2. The script will prompt for variables that must be provided for the script. Alternatively, the values can be provided in a file named `variables.yaml`. An example yaml file has been provided in `variables.template.yaml`.

| Variable               | Description                                                        |
|------------------------|--------------------------------------------------------------------|
| region                 | The region where the resources will be provisioned                 |
| cluster_name           | The name of the cluster                                            |
| resource_group_name    | The name of the resource group                                     |

#### 220 - Dev Tools

1. Run `220-dev-tools/apply.sh`
2. The script will prompt for variables that must be provided for the script. Alternatively, the values can be provided in a file named `variables.yaml`. An example yaml file has been provided in `variables.template.yaml`.

| Variable             | Description                                                        |
|----------------------|--------------------------------------------------------------------|
| gitops_repo_host     | The host of the gitops repo (e.g. github.com)                      |
| gitops_repo_type     | The type of the gitops repo (e.g. github)                          |
| gitops_repo_org      | The existing org/group where the gitops repo will be created/found |
| gitops_repo_repo     | The name for the gitops repo                                       |
| gitops_repo_username | The username that will be used to access the gitops repo           |
