variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "Default region"
  default     = "asia-south1"
}

variable "source_bucket" {
  type = string
}
 
variable "source_object" {
  type = string
}

variable "labels" {
  description = "Common labels"
  type        = map(string)
  default = {
    managed_by = "terraform"
    env        = "dev"
  }
}

variable "composer_name" {
  type = string
}
 
variable "service_account_id" {
  type = string
}
 
variable "network" {
  type = string
}
 
variable "subnetwork" {
  type = string
}
 
variable "image_version" {
  type    = string
  default = "composer-3-airflow-3.1.0"
}
 
variable "env_variables" {
  type    = map(string)
  default = {}
}
 
variable "pypi_packages" {
  type    = map(string)
  default = {}
}
 
variable "environment_size" {
  type    = string
  default = "ENVIRONMENT_SIZE_SMALL"
}