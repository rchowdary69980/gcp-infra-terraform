variable "project_id" {
  description = "GCP project ID where the dataset will be created"
  type        = string
}

variable "dataset_id" {
  description = "Dataset ID (must be unique within the project)"
  type        = string
}

variable "location" {
  description = "Location for BigQuery dataset (e.g., asia-south1)"
  type        = string
  default     = "asia-south1"
}

variable "labels" {
  description = "Labels for the dataset"
  type        = map(string)
  default     = {}
}

variable "default_table_expiration_ms" {
  description = "Default expiration for newly created tables (ms). Null = disabled"
  type        = number
  default     = null
}
