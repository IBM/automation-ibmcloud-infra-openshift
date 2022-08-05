include "root" {
  path = find_in_parent_folders()
}

locals {
    dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

    dep_000 = local.dependencies.names_000
    mock_000 = local.dependencies.mock_000
    account_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_000}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_000}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_000}"

    dep_100 = local.dependencies.names_100
    mock_100 = local.dependencies.mock_100
    shared_services_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_100}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_100}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_100}"
}

dependency "account" {
    config_path = local.account_config_path
    skip_outputs = true
}

dependency "shared_services" {
    config_path = local.shared_services_config_path
    skip_outputs = true
}