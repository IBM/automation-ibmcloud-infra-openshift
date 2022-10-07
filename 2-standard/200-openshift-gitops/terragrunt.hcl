include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

  dep_115 = local.dependencies.names_115
  mock_115 = local.dependencies.mock_115
  cluster_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_115}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_115}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_115}"
}

// Reduce parallelism further for this layer and pause to allow cluster to settle before proceeding
terraform {
  before_hook "pause" {
    commands  = ["apply"]
    execute   = ["sleep","180"]
  }
  extra_arguments "reduced_parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=2"]
  }
}

dependency "openshift" {
    config_path = local.cluster_config_path

    mock_outputs_allowed_terraform_commands = ["init","validate","plan"]
    mock_outputs = {
        resource_group_name = "fake_name"
        cluster_server_url = ""
        cluster_username = ""
        cluster_password = ""
        cluster_token = ""
    }
}

inputs = {
    resource_group_name = dependency.openshift.outputs.resource_group_name
    server_url             = dependency.openshift.outputs.cluster_server_url
    cluster_login_username = dependency.openshift.outputs.cluster_username
    cluster_login_password = dependency.openshift.outputs.cluster_password
    cluster_login_token    = dependency.openshift.outputs.cluster_token
}
