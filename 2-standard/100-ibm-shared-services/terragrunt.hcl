include "root" {
  path = find_in_parent_folders()
}

locals {
    dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

    dep_000 = local.dependencies.names_000
    mock_000 = local.dependencies.mock_000
    account_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_000}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_000}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_000}"
}

dependency "account" {
    config_path = local.account_config_path
    skip_outputs = true
}