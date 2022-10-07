include "root" {
  path = find_in_parent_folders()
}

locals {
    dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

    dep_110 = local.dependencies.names_110
    mock_110 = local.dependencies.mock_110
    edge_vpc_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_110}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_110}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_110}"
}

dependency "edge_vpc" {
    config_path = local.edge_vpc_config_path
    
    mock_outputs_allowed_terraform_commands = ["init","plan","validate"]
    mock_outputs = {
        vpc_resource_group_name = "fake_vpc_rg"
    }
}

inputs = {
    vpc_resource_group_name = dependency.edge_vpc.outputs.vpc_resource_group_name
}