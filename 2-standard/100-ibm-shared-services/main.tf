module "cos" {
  source = "cloud-native-toolkit/object-storage/ibm"
  version = "4.1.0"

  common_tags = var.common_tags == null ? null : jsondecode(var.common_tags)
  ibmcloud_api_key = var.ibmcloud_api_key
  label = var.cos_label
  name_prefix = var.cs_name_prefix
  plan = var.cos_plan
  provision = var.cos_provision
  resource_group_name = module.cs_resource_group.name
  resource_location = var.cos_resource_location
  tags = var.cos_tags == null ? null : jsondecode(var.cos_tags)
}
module "cos-encrypt-auth" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-iam-service-authorization?ref=v1.2.14"

  ibmcloud_api_key = var.ibmcloud_api_key
  provision = var.cos-encrypt-auth_provision
  roles = var.cos-encrypt-auth_roles == null ? null : jsondecode(var.cos-encrypt-auth_roles)
  source_instance = var.cos-encrypt-auth_source_instance
  source_resource_group_id = var.cos-encrypt-auth_source_resource_group_id
  source_resource_instance_id = module.cos.id
  source_resource_type = module.cos.type
  source_service_account = var.cos-encrypt-auth_source_service_account
  source_service_name = module.cos.service
  target_instance = var.cos-encrypt-auth_target_instance
  target_resource_group_id = module.kms_resource_group.id
  target_resource_instance_id = module.kms.id
  target_resource_type = module.kms.type
  target_service_name = module.kms.service
}
module "cs_resource_group" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-resource-group?ref=v3.3.5"

  ibmcloud_api_key = var.ibmcloud_api_key
  purge_volumes = var.purge_volumes
  resource_group_name = var.cs_resource_group_name
  sync = var.cs_resource_group_sync
}
module "flow-log-auth" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-iam-service-authorization?ref=v1.2.14"

  ibmcloud_api_key = var.ibmcloud_api_key
  provision = var.flow-log-auth_provision
  roles = var.flow-log-auth_roles == null ? null : jsondecode(var.flow-log-auth_roles)
  source_instance = var.flow-log-auth_source_instance
  source_resource_group_id = var.flow-log-auth_source_resource_group_id
  source_resource_instance_id = var.flow-log-auth_source_resource_instance_id
  source_resource_type = var.flow-log-auth_source_resource_type
  source_service_account = var.flow-log-auth_source_service_account
  source_service_name = var.flow-log-auth_source_service_name
  target_instance = var.flow-log-auth_target_instance
  target_resource_group_id = module.cs_resource_group.id
  target_resource_instance_id = module.cos.id
  target_resource_type = module.cos.type
  target_service_name = module.cos.service
}
module "ibm-activity-tracker" {
  source = "cloud-native-toolkit/activity-tracker/ibm"
  version = "2.4.18"

  ibmcloud_api_key = var.ibmcloud_api_key
  plan = var.ibm-activity-tracker_plan
  resource_group_name = module.cs_resource_group.name
  resource_location = var.region
  sync = var.ibm-activity-tracker_sync
  tags = var.ibm-activity-tracker_tags == null ? null : jsondecode(var.ibm-activity-tracker_tags)
}
module "ibm-secrets-manager" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-secrets-manager?ref=v1.1.0"

  create_auth = var.ibm-secrets-manager_create_auth
  ibmcloud_api_key = var.ibmcloud_api_key
  kms_enabled = var.ibm-secrets-manager_kms_enabled
  kms_key_crn = module.sm-key.crn
  label = var.ibm-secrets-manager_label
  name = var.ibm-secrets-manager_name
  name_prefix = var.cs_name_prefix
  private_endpoint = var.ibm-secrets-manager_private_endpoint
  provision = var.ibm-secrets-manager_provision
  purge = var.ibm-secrets-manager_purge
  region = var.region
  resource_group_name = module.cs_resource_group.name
  trial = var.ibm-secrets-manager_trial
}
module "kms" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-kms?ref=v0.3.6"

  name = var.kms_name
  name_prefix = var.kms_name_prefix
  number_of_crypto_units = var.kms_number_of_crypto_units
  private_endpoint = var.private_endpoint
  provision = var.kms_provision
  region = var.kms_region
  resource_group_name = module.kms_resource_group.name
  service = var.kms_service
  tags = var.kms_tags == null ? null : jsondecode(var.kms_tags)
}
module "kms_resource_group" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-resource-group?ref=v3.3.5"

  ibmcloud_api_key = var.ibmcloud_api_key
  purge_volumes = var.purge_volumes
  resource_group_name = var.kms_resource_group_name
  sync = module.cs_resource_group.sync
}
module "kube-encrypt-auth" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-iam-service-authorization?ref=v1.2.14"

  ibmcloud_api_key = var.ibmcloud_api_key
  provision = var.kube-encrypt-auth_provision
  roles = var.kube-encrypt-auth_roles == null ? null : jsondecode(var.kube-encrypt-auth_roles)
  source_instance = var.kube-encrypt-auth_source_instance
  source_resource_group_id = module.cs_resource_group.id
  source_resource_instance_id = var.kube-encrypt-auth_source_resource_instance_id
  source_resource_type = var.kube-encrypt-auth_source_resource_type
  source_service_account = var.kube-encrypt-auth_source_service_account
  source_service_name = var.kube-encrypt-auth_source_service_name
  target_instance = var.kube-encrypt-auth_target_instance
  target_resource_group_id = module.kms_resource_group.id
  target_resource_instance_id = module.kms.id
  target_resource_type = module.kms.type
  target_service_name = module.kms.service
}
module "logdna" {
  source = "cloud-native-toolkit/log-analysis/ibm"
  version = "4.1.3"

  label = var.logdna_label
  name = var.logdna_name
  name_prefix = var.cs_name_prefix
  plan = var.logdna_plan
  provision = var.logdna_provision
  region = var.region
  resource_group_name = module.cs_resource_group.name
  tags = var.logdna_tags == null ? null : jsondecode(var.logdna_tags)
}
module "sm-key" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-kms-key?ref=v1.5.4"

  dual_auth_delete = var.sm-key_dual_auth_delete
  force_delete = var.sm-key_force_delete
  kms_id = module.kms.guid
  kms_private_url = module.kms.private_url
  kms_public_url = module.kms.public_url
  label = var.sm-key_label
  name = var.sm-key_name
  name_prefix = var.cs_name_prefix
  provision = var.sm-key_provision
  provision_key_rotation_policy = var.sm-key_provision_key_rotation_policy
  rotation_interval = var.sm-key_rotation_interval
}
module "sysdig" {
  source = "cloud-native-toolkit/cloud-monitoring/ibm"
  version = "4.1.3"

  label = var.sysdig_label
  name = var.sysdig_name
  name_prefix = var.cs_name_prefix
  plan = var.sysdig_plan
  provision = var.sysdig_provision
  region = var.region
  resource_group_name = module.cs_resource_group.name
  tags = var.sysdig_tags == null ? null : jsondecode(var.sysdig_tags)
}
module "vpn-secrets-manager-auth" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-iam-service-authorization?ref=v1.2.14"

  ibmcloud_api_key = var.ibmcloud_api_key
  provision = var.vpn-secrets-manager-auth_provision
  roles = var.vpn-secrets-manager-auth_roles == null ? null : jsondecode(var.vpn-secrets-manager-auth_roles)
  source_instance = var.vpn-secrets-manager-auth_source_instance
  source_resource_group_id = var.vpn-secrets-manager-auth_source_resource_group_id
  source_resource_instance_id = var.vpn-secrets-manager-auth_source_resource_instance_id
  source_resource_type = var.vpn-secrets-manager-auth_source_resource_type
  source_service_account = var.vpn-secrets-manager-auth_source_service_account
  source_service_name = var.vpn-secrets-manager-auth_source_service_name
  target_instance = var.vpn-secrets-manager-auth_target_instance
  target_resource_group_id = var.vpn-secrets-manager-auth_target_resource_group_id
  target_resource_instance_id = var.vpn-secrets-manager-auth_target_resource_instance_id
  target_resource_type = var.vpn-secrets-manager-auth_target_resource_type
  target_service_name = var.vpn-secrets-manager-auth_target_service_name
}
module "vsi-encrypt-auth" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-iam-service-authorization?ref=v1.2.14"

  ibmcloud_api_key = var.ibmcloud_api_key
  provision = var.vsi-encrypt-auth_provision
  roles = var.vsi-encrypt-auth_roles == null ? null : jsondecode(var.vsi-encrypt-auth_roles)
  source_instance = var.vsi-encrypt-auth_source_instance
  source_resource_group_id = var.vsi-encrypt-auth_source_resource_group_id
  source_resource_instance_id = var.vsi-encrypt-auth_source_resource_instance_id
  source_resource_type = var.vsi-encrypt-auth_source_resource_type
  source_service_account = var.vsi-encrypt-auth_source_service_account
  source_service_name = var.vsi-encrypt-auth_source_service_name
  target_instance = var.vsi-encrypt-auth_target_instance
  target_resource_group_id = module.kms_resource_group.id
  target_resource_instance_id = module.kms.id
  target_resource_type = module.kms.type
  target_service_name = module.kms.service
}
module "vsi-encrypt-auth1" {
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-iam-service-authorization?ref=v1.2.14"

  ibmcloud_api_key = var.ibmcloud_api_key
  provision = var.vsi-encrypt-auth1_provision
  roles = var.vsi-encrypt-auth1_roles == null ? null : jsondecode(var.vsi-encrypt-auth1_roles)
  source_instance = var.vsi-encrypt-auth1_source_instance
  source_resource_group_id = module.cs_resource_group.id
  source_resource_instance_id = var.vsi-encrypt-auth1_source_resource_instance_id
  source_resource_type = var.vsi-encrypt-auth1_source_resource_type
  source_service_account = var.vsi-encrypt-auth1_source_service_account
  source_service_name = var.vsi-encrypt-auth1_source_service_name
  target_instance = var.vsi-encrypt-auth1_target_instance
  target_resource_group_id = module.kms_resource_group.id
  target_resource_instance_id = module.kms.id
  target_resource_type = module.kms.type
  target_service_name = module.kms.service
}
