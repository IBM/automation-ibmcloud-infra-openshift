# IBM Cloud Quick Start Reference Architecture

Automation to provision the Quick Start reference architecture on IBM Cloud. This architecture implements the minimum infrastructure required to stand up a managed Red Hat OpenShift cluster with public endpoints.

## Reference Architecture

![QuickStart](architecture.png)

The automation is delivered in a number of layers that are applied in order. Layer `110` provisions the infrastructure including the Red Hat OpenShift cluster and the remaining layers provide configuration inside the cluster. Each layer depends on resources provided in the layer before it (e.g. `200` depends on `110`). Where two layers have the same numbers (e.g. `205`), you have a choice of which layer to apply.

<table>
<thead>
<tr>
<th>Layer name</th>
<th>Layer description</th>
<th>Provided resources</th>
</tr>
</thead>
<tbody>
<tr>
<td>105 - IBM VPC OpenShift</td>
<td>This layer provisions the bulk of the IBM Cloud infrastructure</td>
<td>
<h4>Network</h4>
<ul>
<li>VPC network</li>
<li>VPC Subnet</li>
<li>VPC Public Gateways</li>
<li>Red Hat OpenShift cluster</li>
</ul>
<h4>Shared Services</h4>
<ul>
<li>Object Storage</li>
<li>IBM Log Analysis</li>
<li>IBM Cloud Monitoring</li>
</ul>
</td>
</tr>
<tr>
<td>200 - IBM OpenShift Gitops</td>
<td>This layer provisions OpenShift CI/CD tools into the cluster, a GitOps repository, and bootstraps the repository to the OpenShift Gitops instance.</td>
<td>
<h4>Software</h4>
<ul>
<li>OpenShift GitOps (ArgoCD)</li>
<li>OpenShift Pipelines (Tekton)</li>
<li>Sealed Secrets (Kubeseal)</li>
<li>GitOps repo</li>
</ul>
</td>
</tr>
<tr>
<td>205 - IBM Storage</td>
<td>The storage layer offers two options: `odf` and `portworx`. Either odf or portworx storage can be installed (or in rare instances, both).</td>
<td>
<h4>ODF Storage</h4>
<ul>
<li>ODF operator</li>
<li>ODF storage classes</li>
</ul>
<h4>Portworx Storage</h4>
<ul>
<li>IBM Cloud storage volumes</li>
<li>Portworx operator</li>
<li>Portworx storage classes</li>
</ul>
</td>
</tr>
<tr>
<td>220 - Dev Tools</td>
<td>The dev tools layer installs standard continuous integration (CI) pipelines that integrate with tools that support the software development lifecycle.</td>
<td>
<h4>Software</h4>
<ul>
<li>Artifactory</li>
<li>Developer Dashboard</li>
<li>Pact Broker</li>
<li>Sonarqube</li>
<li>Tekton Resources</li>
</ul>
</td>
</tr>
</tbody>
</table>

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
2. Copy **credentials.template** to **credentials.properties**.
3. Provide your IBM Cloud API key as the value for the `TF_VAR_ibmcloud_api_key` variable in **credentials.properties** (**Note:** `*.properties` has been added to `.gitignore` to ensure that the file containing the apikey cannot be checked into Git.)
4. Run `./launch.sh`. This will start a container image with the prompt opened in the **/terraform** directory.
5. Create a working copy of the terraform by running `./setup-workspace.sh`. Select "1" to set up the workspace for Quick Start. The script makes a copy of the terraform in **/workspaces/current** and sets up an empty **terraform.tfvars** file.
6. Change the directory to the subdirectory to the workspace that was just created - `cd /workspaces/current`

### Running each layer of automation sequentially

#### Configuration values

Configuration values need to be provided to terraform when the script is run. If not provided in advance, the terraform cli will prompt for them. However, to ensure the automation is applied consistently at each layer we highly recommend providing the values in a configuration file up front.

1. Uncomment and provide a value for each of the variables in **/workspaces/current/terraform.tfvars**. The **/workspaces/current/terraform.tfvars** file is shared between different terraform layers via a soft link so the values only need to be provided in one place.
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
| odf_namespace_name     | The namespace where the odf resource should be deployed                |

**Note:** The `ibmcloud_api_key`, `gitops_repo_username` and `gitops_repo_token` variables should have been provided in the **credentials.properties** file and provided as environment variables into the container. If you are not running in a container, you can add the variables in the terraform.tfvars file or provide them when prompted.

#### 105 - IBM VPC OpenShift

1. Change the directory to `105-ibm-vpc-openshift/terraform`
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

#### 200 - IBM OpenShift Gitops

1. Change the directory to `200-ibm-openshift-gitops/terraform`
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

#### 205 - IBM Storage

Most of the IBM Cloud Pak software components have a special storage requirements and need a storage manager installed in the cluster. The Quick Start currently provides two options: **ODF storage** and **Portworx storage**. Each has different characteristics so pick the one that works best for your deployment. If you don't plan to install IBM Cloud Paks at this time you can skip this layer and apply it later when/if the need arises.

##### 205 - IBM ODF Storage

1. Change the directory to `205-ibm-odf-storage/terraform`
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

##### 205 - IBM Portworx Storage

1. Change the directory to `205-ibm-portworx-storage/terraform`
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
