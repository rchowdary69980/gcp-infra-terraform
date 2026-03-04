variable "project_id" {
  type = string
}
 
variable "region" {
  type = string
}
 
variable "composer_name" {
  type = string
}
 
variable "service_account_id" {
  description = "ID of the service account (without domain), e.g. composer-sa"
  type        = string
}
 
variable "image_version" {
  description = "Cloud Composer 2 image version"
  type        = string
}
 
variable "env_variables" {
  description = "Environment variables passed to Airflow"
  type        = map(string)
  default     = {}
}
 
variable "pypi_packages" {
  description = "Map of PyPI packages to install"
  type        = map(string)
  default     = {}
}
 
variable "environment_size" {
  description = "Cloud Composer environment size"
  type        = string
  default     = "ENVIRONMENT_SIZE_SMALL"
}
 
variable "network" {
  description = "Name or self link of VPC network"
  type        = string
}
 
variable "subnetwork" {
  description = "Name or self link of subnetwork"
  type        = string
}