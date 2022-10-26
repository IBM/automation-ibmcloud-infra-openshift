

terraform {
  # Connect to VPN if required for terraform (checks the bom.yaml)
  before_hook "check_vpn" {
      commands        = ["apply","plan","destroy","validate","output"]
      execute         = ["bash", "${get_parent_terragrunt_dir()}/check-vpn.sh"]
      run_on_error    = true
  }
  # Reduce number of parallel executions to improve reliability with github actions
  extra_arguments "reduced_parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=6"]
  }
  # Include common TFVAR variables
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()

    required_var_files = [
      "${get_parent_terragrunt_dir()}/cluster.tfvars",
      "${get_parent_terragrunt_dir()}/gitops.tfvars"
    ]
  }
}

retryable_errors = [
  "(?s).*igc gitops-module.*",
  "(?s).*Status.code:.503*",
  "(?s).*o.timeout*",
  "(?s).Error:.self.signed.certificate.in.certificate.chain*",
  "(?s).Error getting resource tags*"
]

retry_sleep_interval_sec = 60
retry_max_attempts = 5
skip = true