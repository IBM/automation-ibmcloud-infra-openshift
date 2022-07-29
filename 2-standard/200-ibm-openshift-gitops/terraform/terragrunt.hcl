dependencies {
    paths = ["../115-ibm-vpc-openshift-standard"]
}

dependency "openshift" {
    config_path = "../115-ibm-vpc-openshift-standard"

    mock_outputs_allowed_terraform_commands = ["init","validate","plan"]
    mock_outputs = {
        resource_group_name = "fake_name"
    }
}

inputs = {
    resource_group_name = dependency.openshift.outputs.resource_group_name
}

terraform {
    # Connect to VPN if required for terraform (checks the bom.yaml)
    before_hook "check_vpn" {
        commands        = ["apply","plan","destroy"]
        execute         = ["bash", "../check-vpn.sh"]
        run_on_error    = true
    }
    # Ensures paralellism never exceed three modules at any time
    extra_arguments "reduced_parallelism" {
        commands  = get_terraform_commands_that_need_parallelism()
        arguments = ["-parallelism=3"]
    }
}