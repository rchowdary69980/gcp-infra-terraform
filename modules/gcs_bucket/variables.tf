variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "name" {
  description = "Globally unique bucket name"
  type        = string
}

variable "location" {
  description = "Bucket location (e.g., ASIA-SOUTH1 for Mumbai)"
  type        = string
  default     = "ASIA-SOUTH1"
}

variable "storage_class" {
  description = "Storage class (STANDARD, NEARLINE, COLDLINE, ARCHIVE)"
  type        = string
  default     = "STANDARD"
}

variable "versioning" {
  description = "Enable object versioning for recovery and audit"
  type        = bool
  default     = true
}

variable "ubla" {
  description = "Uniform bucket-level access (disables per-object ACLs)"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow bucket to be destroyed even if it contains objects"
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels for cost/accountability"
  type        = map(string)
  default     = {}
}

variable "log_object_prefix" {
  description = "Object prefix for access logs in the log bucket"
  type        = string
  default     = "logs/"
}