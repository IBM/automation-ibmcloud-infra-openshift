resource local_file output {
  filename = "${path.cwd}/cluster.auto.tfvars.json"

  content = jsonencode({
    cluster_server_url = module.cluster.server_url
    cluster_username = module.cluster.username
    cluster_password = module.cluster.password
    cluster_token = module.cluster.token
    cluster_ingress = module.cluster.platform.ingress
  })
}
