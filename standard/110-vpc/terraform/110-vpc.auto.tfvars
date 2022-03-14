## kms_resource_group_name: The name of the resource group
#kms_resource_group_name=""

## ibmcloud_api_key: the value of ibmcloud_api_key
#ibmcloud_api_key=""

## region: the value of region
#region=""

## at_resource_group_name: The name of the resource group
#at_resource_group_name=""

## vpc_resource_group_name: The name of the resource group
#vpc_resource_group_name=""

## vpc_resource_group_provision: Flag indicating that the resource group should be created
#vpc_resource_group_provision="true"

## cs_resource_group_name: The name of the resource group
#cs_resource_group_name=""

## kms_region: Geographic location of the resource (e.g. us-south, us-east)
#kms_region=""

## kms_service: The name of the KMS provider that should be used (keyprotect or hpcs)
#kms_service="keyprotect"

## vpc_name_prefix: The name_prefix used to build the name if one is not provided. If used the name will be `{name_prefix}-{label}`
#vpc_name_prefix="base"

## cs_name_prefix: The name prefix for the Certificate Manager resource. If not provided will default to resource group name.
#cs_name_prefix=""

## worker_count: The number of worker nodes that should be provisioned for classic infrastructure
#worker_count="3"

## cluster_flavor: The machine type that will be provisioned for classic infrastructure
#cluster_flavor="bx2.4x16"

## vpc_ssh_bastion_public_key: The public key provided for the ssh key. If empty string is provided then a new key will be generated.
#vpc_ssh_bastion_public_key=""

## vpc_ssh_bastion_private_key: The private key provided for the ssh key. If empty string is provided then a new key will be generated.
#vpc_ssh_bastion_private_key=""

## vpc_ssh_bastion_public_key_file: The name of the file containing the public key provided for the ssh key. If empty string is provided then a new key will be generated.
#vpc_ssh_bastion_public_key_file=""

## vpc_ssh_bastion_private_key_file: The name of the file containing the private key provided for the ssh key. If empty string is provided then a new key will be generated.
#vpc_ssh_bastion_private_key_file=""

## ingress-subnets__count: The number of subnets that should be provisioned
#ingress-subnets__count="3"

## bastion-subnets__count: The number of subnets that should be provisioned
#bastion-subnets__count="3"

## egress-subnets__count: The number of subnets that should be provisioned
#egress-subnets__count="3"

## mgmt_worker_subnet_count: The number of subnets that should be provisioned
#mgmt_worker_subnet_count="3"

## vpe-subnets__count: The number of subnets that should be provisioned
#vpe-subnets__count="3"

## gitops-repo_host: The host for the git repository.
#gitops-repo_host=""

## gitops-repo_type: The type of the hosted git repository (github or gitlab).
#gitops-repo_type=""

## gitops-repo_org: The org/group where the git repository exists/will be provisioned.
#gitops-repo_org=""

## gitops-repo_repo: The short name of the repository (i.e. the part after the org/group name)
#gitops-repo_repo=""

## gitops-repo_username: The username of the user with access to the repository
#gitops-repo_username=""

## gitops-repo_token: The personal access token used to access the repository
#gitops-repo_token=""

