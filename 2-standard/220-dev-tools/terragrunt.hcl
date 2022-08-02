include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

  dep_115 = local.dependencies.names_115
  mock_115 = local.dependencies.mock_115
  cluster_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_115}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_115}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_115}"

  dep_200 = local.dependencies.names_200
  mock_200 = local.dependencies.mock_200
  gitops_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_200}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_200}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_200}"
}

dependency "openshift" {
    config_path = local.cluster_config_path
    skip_outputs = true
}

dependency "gitops" {
    config_path = local.gitops_config_path
    skip_outputs = true
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