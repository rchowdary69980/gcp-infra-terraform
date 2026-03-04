variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "location" {
  description = "GKE cluster region (e.g., asia-south1)"
  type        = string
}

variable "name" {
  description = "Cluster name"
  type        = string
}

variable "network" {
  description = "VPC network name or self_link"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name or self_link"
  type        = string
}

variable "cluster_secondary_range_name" {
  description = "Secondary IP range for Pods"
  type        = string
}

variable "services_secondary_range_name" {
  description = "Secondary IP range for Services"
  type        = string
}

variable "node_pool_name" {
  description = "Name of the node pool"
  type        = string
}

variable "machine_type" {
  description = "Node machine type"
  type        = string
  default     = "n1-standard-1"
}

variable "min_nodes" {
  description = "Minimum nodes for autoscaler"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "Maximum nodes for autoscaler"
  type        = number
  default     = 1
}

variable "disk_size_gb" {
  description = "Node disk size in GB"
  type        = number
  default     = 10
}


variable "disk_type" {
  description = "Node boot disk type: pd-standard | pd-balanced | pd-ssd"
  type        = string
  default     = "pd-standard"
}
