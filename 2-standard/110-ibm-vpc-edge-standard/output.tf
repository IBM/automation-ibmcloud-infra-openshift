output "ibm-activity-tracker_id" {
  description = "The id of the provisioned instance."
  value = module.ibm-activity-tracker.id
}
output "ibm-activity-tracker_guid" {
  description = "The id of the provisioned instance."
  value = module.ibm-activity-tracker.guid
}
output "ibm-activity-tracker_name" {
  description = "The name of the provisioned instance."
  value = module.ibm-activity-tracker.name
}
output "ibm-activity-tracker_crn" {
  description = "The id of the provisioned instance"
  value = module.ibm-activity-tracker.crn
}
output "ibm-activity-tracker_location" {
  description = "The location of the provisioned instance"
  value = module.ibm-activity-tracker.location
}
output "ibm-activity-tracker_service" {
  description = "The service name of the key provisioned for the instance"
  value = module.ibm-activity-tracker.service
}
output "ibm-activity-tracker_label" {
  description = "The label for the instance"
  value = module.ibm-activity-tracker.label
}
output "ibm-activity-tracker_sync" {
  description = "Value used to order the provisioning of the instance"
  value = module.ibm-activity-tracker.sync
}
output "ibm-flow-logs_count" {
  description = "The number of flow logs created"
  value = module.ibm-flow-logs.count
}
output "ibm-flow-logs_ids" {
  description = "The ids of the generated flow logs"
  value = module.ibm-flow-logs.ids
}
output "ibm-flow-logs_names" {
  description = "The names of the generated flow logs"
  value = module.ibm-flow-logs.names
}
output "kms_id" {
  description = "The id of the provisioned instance."
  value = module.kms.id
}
output "kms_guid" {
  description = "The id of the provisioned instance."
  value = module.kms.guid
}
output "kms_name" {
  description = "The name of the provisioned instance."
  value = module.kms.name
}
output "kms_crn" {
  description = "The id of the provisioned instance"
  value = module.kms.crn
}
output "kms_location" {
  description = "The location of the provisioned instance"
  value = module.kms.location
}
output "kms_service" {
  description = "The service name of the key provisioned for the instance"
  value = module.kms.service
}
output "kms_label" {
  description = "The label for the instance"
  value = module.kms.label
}
output "kms_type" {
  description = "The type of the resource"
  value = module.kms.type
}
output "kms_public_url" {
  description = "The public endpoint for the resource"
  value = module.kms.public_url
}
output "kms_private_url" {
  description = "The private endpoint for the resource"
  value = module.kms.private_url
}
output "cos_key_id" {
  description = "The id of the key"
  value = module.cos_key.id
}
output "cos_key_name" {
  description = "The crn of the key"
  value = module.cos_key.name
}
output "cos_key_crn" {
  description = "The crn of the key"
  value = module.cos_key.crn
}
output "cos_key_kms_id" {
  description = "The id of the kms instance"
  value = module.cos_key.kms_id
}
output "cos_key_kms_public_url" {
  description = "The public url of the kms instance"
  value = module.cos_key.kms_public_url
}
output "cos_key_kms_private_url" {
  description = "The private url of the kms instance"
  value = module.cos_key.kms_private_url
}
output "kms_resource_group_name" {
  description = "The name of the resource group"
  value = module.kms_resource_group.name
}
output "kms_resource_group_id" {
  description = "The id of the resource group"
  value = module.kms_resource_group.id
}
output "kms_resource_group_group" {
  description = "The resource group object"
  value = module.kms_resource_group.group
}
output "kms_resource_group_sync" {
  description = "Value used to order the provisioning of the resource group"
  value = module.kms_resource_group.sync
}
output "kms_resource_group_provision" {
  description = "Flag indicating that the resource group was provisioned by this module"
  value = module.kms_resource_group.provision
}
output "kms_resource_group_tags" {
  description = "Flag indicating that the resource group was provisioned by this module"
  value = module.kms_resource_group.tags
}
output "vpc_resource_group_name" {
  description = "The name of the resource group"
  value = module.vpc_resource_group.name
}
output "vpc_resource_group_id" {
  description = "The id of the resource group"
  value = module.vpc_resource_group.id
}
output "vpc_resource_group_group" {
  description = "The resource group object"
  value = module.vpc_resource_group.group
}
output "vpc_resource_group_sync" {
  description = "Value used to order the provisioning of the resource group"
  value = module.vpc_resource_group.sync
}
output "vpc_resource_group_provision" {
  description = "Flag indicating that the resource group was provisioned by this module"
  value = module.vpc_resource_group.provision
}
output "vpc_resource_group_tags" {
  description = "Flag indicating that the resource group was provisioned by this module"
  value = module.vpc_resource_group.tags
}
output "cs_resource_group_name" {
  description = "The name of the resource group"
  value = module.cs_resource_group.name
}
output "cs_resource_group_id" {
  description = "The id of the resource group"
  value = module.cs_resource_group.id
}
output "cs_resource_group_group" {
  description = "The resource group object"
  value = module.cs_resource_group.group
}
output "cs_resource_group_sync" {
  description = "Value used to order the provisioning of the resource group"
  value = module.cs_resource_group.sync
}
output "cs_resource_group_provision" {
  description = "Flag indicating that the resource group was provisioned by this module"
  value = module.cs_resource_group.provision
}
output "cs_resource_group_tags" {
  description = "Flag indicating that the resource group was provisioned by this module"
  value = module.cs_resource_group.tags
}
output "cos_id" {
  description = "The Object Storage instance id"
  value = module.cos.id
}
output "cos_name" {
  description = "The Object Storage instance name"
  value = module.cos.name
}
output "cos_crn" {
  description = "The crn of the Object Storage instance"
  value = module.cos.crn
}
output "cos_location" {
  description = "The Object Storage instance location"
  value = module.cos.location
}
output "cos_service" {
  description = "The name of the key provisioned for the Object Storage instance"
  value = module.cos.service
}
output "cos_label" {
  description = "The label used for the Object Storage instance"
  value = module.cos.label
}
output "cos_type" {
  description = "The type of the resource"
  value = module.cos.type
}
output "flow_log_bucket_bucket_name" {
  description = "The name of the COS bucket instance"
  value = module.flow_log_bucket.bucket_name
}
output "flow_log_bucket_id" {
  description = "The ID of the COS bucket instance"
  value = module.flow_log_bucket.id
}
output "flow_log_bucket_crn" {
  description = "The CRN of the COS bucket instance"
  value = module.flow_log_bucket.crn
}
output "ibm-secrets-manager_id" {
  description = "The Secrets Manager instance CRN id"
  value = module.ibm-secrets-manager.id
}
output "ibm-secrets-manager_guid" {
  description = "The Secrets Manager instance guid"
  value = module.ibm-secrets-manager.guid
}
output "ibm-secrets-manager_name" {
  description = "The Secrets Manager instance name"
  value = module.ibm-secrets-manager.name
}
output "ibm-secrets-manager_crn" {
  description = "The crn of the Secrets Manager instance"
  value = module.ibm-secrets-manager.crn
}
output "ibm-secrets-manager_location" {
  description = "The Secrets Manager instance location"
  value = module.ibm-secrets-manager.location
}
output "ibm-secrets-manager_service" {
  description = "The name of the service provisioned for the Secrets Manager instance"
  value = module.ibm-secrets-manager.service
}
output "ibm-secrets-manager_plan" {
  description = "The plan of the service provisioned"
  value = module.ibm-secrets-manager.plan
}
output "ibm-vpc_name" {
  description = "The name of the vpc instance"
  value = module.ibm-vpc.name
}
output "ibm-vpc_id" {
  description = "The id of the vpc instance"
  value = module.ibm-vpc.id
}
output "ibm-vpc_acl_id" {
  description = "The id of the network acl"
  value = module.ibm-vpc.acl_id
}
output "ibm-vpc_crn" {
  description = "The CRN for the vpc instance"
  value = module.ibm-vpc.crn
}
output "ibm-vpc_count" {
  description = "The number of VPCs created by this module. Always set to 1"
  value = module.ibm-vpc.count
}
output "ibm-vpc_names" {
  description = "The name of the vpc instance"
  value = module.ibm-vpc.names
}
output "ibm-vpc_ids" {
  description = "The id of the vpc instance"
  value = module.ibm-vpc.ids
}
output "ibm-vpc_base_security_group" {
  description = "The id of the base security group to be shared by other resources. The base group is different from the default security group."
  value = module.ibm-vpc.base_security_group
}
output "ibm-vpc_addresses" {
  description = "The ip address ranges for the VPC"
  value = module.ibm-vpc.addresses
}
output "ibm-vpc-gateways_count" {
  description = "The number of gateways created"
  value = module.ibm-vpc-gateways.count
}
output "ibm-vpc-gateways_gateway_ids" {
  description = "List of ids of the gateways created"
  value = module.ibm-vpc-gateways.gateway_ids
}
output "ibm-vpc-gateways_gateways" {
  description = "List of ids and zones of gateways created"
  value = module.ibm-vpc-gateways.gateways
}
output "ingress-subnets_count" {
  description = "The number of subnets created"
  value = module.ingress-subnets.count
}
output "ingress-subnets_ids" {
  description = "The ids of the created subnets"
  value = module.ingress-subnets.ids
}
output "ingress-subnets_names" {
  description = "The ids of the created subnets"
  value = module.ingress-subnets.names
}
output "ingress-subnets_subnets" {
  description = "The subnets that were created"
  value = module.ingress-subnets.subnets
}
output "ingress-subnets_acl_id" {
  description = "The id of the network acl for the subnets"
  value = module.ingress-subnets.acl_id
}
output "ingress-subnets_vpc_name" {
  description = "The name of the VPC where the subnets were provisioned"
  value = module.ingress-subnets.vpc_name
}
output "ingress-subnets_vpc_id" {
  description = "The id of the VPC where the subnets were provisioned"
  value = module.ingress-subnets.vpc_id
}
output "egress-subnets_count" {
  description = "The number of subnets created"
  value = module.egress-subnets.count
}
output "egress-subnets_ids" {
  description = "The ids of the created subnets"
  value = module.egress-subnets.ids
}
output "egress-subnets_names" {
  description = "The ids of the created subnets"
  value = module.egress-subnets.names
}
output "egress-subnets_subnets" {
  description = "The subnets that were created"
  value = module.egress-subnets.subnets
}
output "egress-subnets_acl_id" {
  description = "The id of the network acl for the subnets"
  value = module.egress-subnets.acl_id
}
output "egress-subnets_vpc_name" {
  description = "The name of the VPC where the subnets were provisioned"
  value = module.egress-subnets.vpc_name
}
output "egress-subnets_vpc_id" {
  description = "The id of the VPC where the subnets were provisioned"
  value = module.egress-subnets.vpc_id
}
output "ibm-vpn-server_name" {
  description = "The name of the VPN server instance"
  value = module.ibm-vpn-server.name
}
output "ibm-vpn-server_server_certificate" {
  description = "The CRN of the server certificate saved to the certificate manager instance"
  value = module.ibm-vpn-server.server_certificate
}
output "ibm-vpn-server_client_certificate" {
  description = "The CRN of the client certificate saved to the certificate manager instance"
  value = module.ibm-vpn-server.client_certificate
}
output "ibm-vpn-server_vpn_profile" {
  description = "The filename of the VPN client configuration file"
  value = module.ibm-vpn-server.vpn_profile
}
