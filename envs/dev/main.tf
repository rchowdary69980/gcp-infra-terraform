###gcs_bucket module is used to create a Google Cloud Storage bucket for storing artifacts.
module "artifact_bucket" {
  source        = "../../modules/gcs_bucket"

  project_id    = var.project_id
  name          = "artifacts-${var.project_id}"   # must be globally unique
  location      = "ASIA-SOUTH1"
  storage_class = "STANDARD"
  versioning    = true
  ubla          = true
  force_destroy = false
  labels        = {
    env   = "dev"
    owner = "rahul"
  }
}

output "artifact_bucket_name" {
  description = "Name of the created bucket"
  value       = module.artifact_bucket.bucket_name
}

output "artifact_bucket_url" {
  description = "gs:// URL for the bucket"
  value       = module.artifact_bucket.bucket_url
}


###bigquery_dataset module is used to create a BigQuery dataset for storing query results and metadata.
module "bq_dataset" {
  source     = "../../modules/bigquery_dataset"
  project_id = var.project_id
  dataset_id = "analytics_3"      # We can change this
  location   = "asia-south1"
  labels = {
    env   = "dev"
    owner = "rahul"
  }
}

output "bigquery_dataset_id" {
  value = module.bq_dataset.dataset_id
}

output "bigquery_dataset_self_link" {
  value = module.bq_dataset.dataset_self_link
}


##cloud_function_v2 module is used to create a Cloud Function that will be triggered by Pub/Sub messages.
###We need to enable the required APIs for Cloud Functions, Cloud Run, Cloud Build, Artifact Registry, and Eventarc.

module "cloud_function_v2" {
  source = "../../modules/cloud_function_v2"
 
  name          = "hello-fn-v2"
  region        = var.region
  runtime       = "python311"
  entry_point   = "main"
 
  source_bucket = var.source_bucket
  source_object = var.source_object
 
  labels        = var.labels
}

output "function_v2_name" {
  value = module.cloud_function_v2.function_name
}
 
output "function_v2_url" {
  value = module.cloud_function_v2.uri
}

###gke_cluster module is used to create a GKE cluster for running containerized workloads.
###############################
# 1) Minimal Networking
###############################
resource "google_compute_network" "vpc" {
  name                    = "vpc-main"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "apps" {
  name          = "apps-a-south1"
  region        = var.region
  network       = google_compute_network.vpc.self_link
  ip_cidr_range = "10.10.0.0/24"

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.20.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.30.0.0/20"
  }
}

###############################
# 2) Enable Required APIs
###############################
resource "google_project_service" "gke_apis" {
  for_each = toset([
    "container.googleapis.com",   # GKE control plane
    "composer.googleapis.com",         # ✅ Cloud Composer
    "compute.googleapis.com",     # VPC, subnets
    "iam.googleapis.com",         # Workload Identity
    "logging.googleapis.com",     # GKE logging
    "monitoring.googleapis.com"   # GKE metrics
  ])
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}


###############################
# 3) GKE Cluster (module)
###############################
module "gke_cluster" {
  source     = "../../modules/gke_cluster"
  project_id = var.project_id
  location   = "asia-south1-b"     # <-- make it ZONAL for speed & fewer MIGs
  name       = "demo-gke"

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.apps.name

  cluster_secondary_range_name  = "pods"
  services_secondary_range_name = "services"

  node_pool_name = "default-pool"
  machine_type   = "e2-standard-2" # smaller = faster & less quota needed
  min_nodes      = 1
  max_nodes      = 1
  disk_size_gb   = 20              # a bit more disk headroom
  disk_type      = "pd-balanced"   # better default than pd-standard

  # Ensure APIs & SUBNET exist before cluster
  depends_on = [
    google_project_service.gke_apis,
    google_compute_subnetwork.apps
  ]
}
###############################
# 4) Helpful Outputs
###############################
output "gke_cluster_name" {
  value = module.gke_cluster.cluster_name
}

output "gke_endpoint" {
  value = module.gke_cluster.endpoint
}


###cloud_composer_v2 module is used to create a Cloud Composer environment for orchestrating workflows.
module "cloud_composer" {
  source = "../../modules/cloud_composer_v2"
 
  project_id         = var.project_id
  region             = var.region
  composer_name      = var.composer_name
  service_account_id = var.service_account_id
 
  network    = var.network
  subnetwork = var.subnetwork
 
  image_version = var.image_version
 
  env_variables     = var.env_variables
  pypi_packages     = var.pypi_packages
  environment_size  = var.environment_size
}