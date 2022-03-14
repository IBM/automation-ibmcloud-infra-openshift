module "at-eu-de" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-activity-tracker?ref=v2.4.0"

  plan = var.at-eu-de_plan
  provision = var.at-eu-de_provision
  resource_group_name = module.resource_group.name
  resource_location = var.at-eu-de_region
  tags = var.at-eu-de_tags == null ? null : jsondecode(var.at-eu-de_tags)
}
module "at-eu-gb" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-activity-tracker?ref=v2.4.0"

  plan = var.at-eu-gb_plan
  provision = var.at-eu-gb_provision
  resource_group_name = module.resource_group.name
  resource_location = var.at-eu-gb_region
  tags = var.at-eu-gb_tags == null ? null : jsondecode(var.at-eu-gb_tags)
}
module "at-us-east" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-activity-tracker?ref=v2.4.0"

  plan = var.at-us-east_plan
  provision = var.at-us-east_provision
  resource_group_name = module.resource_group.name
  resource_location = var.at-us-east_region
  tags = var.at-us-east_tags == null ? null : jsondecode(var.at-us-east_tags)
}
module "at-us-south" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-activity-tracker?ref=v2.4.0"

  plan = var.at-us-south_plan
  provision = var.at-us-south_provision
  resource_group_name = module.resource_group.name
  resource_location = var.at-us-south_region
  tags = var.at-us-south_tags == null ? null : jsondecode(var.at-us-south_tags)
}
module "resource_group" {
  source = "cloud-native-toolkit/resource-group/ibm"
  version = "3.2.2"

  provision = var.at_resource_group_provision
  resource_group_name = var.at_resource_group_name
  sync = var.resource_group_sync
}
