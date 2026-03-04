variable "name" {
  description = "Name of the Cloud Function v2"
  type        = string
}
 
variable "runtime" {
  description = "Runtime for the cloud function"
  type        = string
  default     = "python311"
}
 
variable "entry_point" {
  description = "Entry point function name"
  type        = string
}
 
variable "region" {
  description = "Region for Cloud Function"
  type        = string
}
 
variable "source_bucket" {
  description = "Bucket where the function ZIP is stored"
  type        = string
}
 
variable "source_object" {
  description = "ZIP file path inside the GCS bucket"
  type        = string
}
 
variable "labels" {
  description = "Labels for the function"
  type        = map(string)
  default     = {}
}