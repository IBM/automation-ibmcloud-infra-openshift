dependencies {
    paths = ["../115-ibm-vpc-openshift-standard","../200-ibm-openshift-gitops"]
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