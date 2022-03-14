variable "at_resource_group_name" {
  type = string
  description = "The name of the resource group"
}
variable "at_resource_group_provision" {
  type = bool
  description = "Flag indicating that the resource group should be created"
  default = false
}
variable "resource_group_sync" {
  type = string
  description = "Value used to order the provisioning of the resource group"
  default = ""
}
variable "ibmcloud_api_key" {
  type = string
  description = "the value of ibmcloud_api_key"
}
variable "region" {
  type = string
  description = "the value of region"
}
variable "at-us-east_region" {
  type = string
  description = "Geographic location of the resource (e.g. us-south, us-east)"
  default = "us-east"
}
variable "at-us-east_tags" {
  type = string
  description = "Tags that should be applied to the service"
  default = "[]"
}
variable "at-us-east_plan" {
  type = string
  description = "The type of plan the service instance should run under (lite, 7-day, 14-day, or 30-day)"
  default = "7-day"
}
variable "at-us-east_provision" {
  type = bool
  description = "Flag indicating that the instance should be provisioned"
  default = true
}
variable "at-us-south_region" {
  type = string
  description = "Geographic location of the resource (e.g. us-south, us-east)"
  default = "us-south"
}
variable "at-us-south_tags" {
  type = string
  description = "Tags that should be applied to the service"
  default = "[]"
}
variable "at-us-south_plan" {
  type = string
  description = "The type of plan the service instance should run under (lite, 7-day, 14-day, or 30-day)"
  default = "7-day"
}
variable "at-us-south_provision" {
  type = bool
  description = "Flag indicating that the instance should be provisioned"
  default = true
}
variable "at-eu-de_region" {
  type = string
  description = "Geographic location of the resource (e.g. us-south, us-east)"
  default = "eu-de"
}
variable "at-eu-de_tags" {
  type = string
  description = "Tags that should be applied to the service"
  default = "[]"
}
variable "at-eu-de_plan" {
  type = string
  description = "The type of plan the service instance should run under (lite, 7-day, 14-day, or 30-day)"
  default = "7-day"
}
variable "at-eu-de_provision" {
  type = bool
  description = "Flag indicating that the instance should be provisioned"
  default = true
}
variable "at-eu-gb_region" {
  type = string
  description = "Geographic location of the resource (e.g. us-south, us-east)"
  default = "eu-gb"
}
variable "at-eu-gb_tags" {
  type = string
  description = "Tags that should be applied to the service"
  default = "[]"
}
variable "at-eu-gb_plan" {
  type = string
  description = "The type of plan the service instance should run under (lite, 7-day, 14-day, or 30-day)"
  default = "7-day"
}
variable "at-eu-gb_provision" {
  type = bool
  description = "Flag indicating that the instance should be provisioned"
  default = true
}
