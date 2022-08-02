include "root" {
  path = find_in_parent_folders()
}

locals {
    dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

    dep_110 = local.dependencies.names_110
    mock_110 = local.dependencies.mock_110
    edge_vpc_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_110}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_110}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_110}"
}

terraform {
    # Connect to VPN if required for terraform (checks the bom.yaml)
    before_hook "check_vpn" {
        commands        = ["apply","plan","destroy","validate","output"]
        execute         = ["bash", "../check-vpn.sh"]
        run_on_error    = true
    }
    # Ensures paralellism never exceed three modules at any time
    extra_arguments "reduced_parallelism" {
        commands  = get_terraform_commands_that_need_parallelism()
        arguments = ["-parallelism=3"]
    }
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