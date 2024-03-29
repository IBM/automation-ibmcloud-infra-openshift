output "resource_group_name" {
  value = module.vpc_resource_group.name
}

output "cluster_server_url" {
  value = module.cluster.server_url
}

output "cluster_username" {
  value = module.cluster.username
}

output "cluster_password" {
  value = module.cluster.password
  sensitive = true
}

output "cluster_token" {
  value = module.cluster.token
  sensitive = true
}

output "cluster_ingress" {
  value = module.cluster.platform.ingress
  sensitive = true
}