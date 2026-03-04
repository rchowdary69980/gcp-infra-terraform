resource "google_project_service" "composer_api" {
  project             = var.project_id
  service             = "composer.googleapis.com"
  disable_on_destroy  = false
}
 
resource "google_project_service" "required_apis" {
  # Other services Composer 2 relies on
  for_each = toset([
    "compute.googleapis.com",
    "storage.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com"
  ])
 
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}
 
# ------------ Service Account ------------
resource "google_service_account" "composer_sa" {
  project      = var.project_id
  account_id   = var.service_account_id              # e.g., "composer-demo-sa"
  display_name = "Composer Environment Service Account"
}
 
# ------------ IAM for Service Account ------------
# Minimum set to run Composer 2 and access GCS for DAGs/plugins.
# You can tighten storage permissions later (e.g., objectViewer/objectCreator).
resource "google_project_iam_member" "composer_roles" {
  for_each = toset([
    "roles/composer.worker",
    "roles/storage.objectAdmin",
    "roles/iam.serviceAccountTokenCreator",
  ])
 
  project = var.project_id
  member  = "serviceAccount:${google_service_account.composer_sa.email}"
  role    = each.key
}
 
# ------------ Composer 2 Environment ------------
resource "google_composer_environment" "composer_env" {
  # Ensure APIs + IAM are ready before environment creation
  depends_on = [
    google_project_service.composer_api,
    google_project_service.required_apis,
    google_project_iam_member.composer_roles
  ]
 
  name    = var.composer_name
  region  = var.region
  project = var.project_id
 
  config {
    # IMPORTANT: In Composer 2 you MUST set the service account here.
    # Do NOT set unsupported fields like location/machine_type (Autopilot manages nodes).
    node_config {
      service_account = google_service_account.composer_sa.email
 
      # Network wiring (required in many orgs).
      # Accepts name or self-link. Make sure subnetwork belongs to the same region.
      network    = var.network
      subnetwork = var.subnetwork
    }
 
    software_config {
      # Example: "composer-2.5.1-airflow-2.7.1"
      image_version = var.image_version
 
      # Optional environment variables available to Airflow
      env_variables = var.env_variables
 
      # Optional PyPI packages: map of package -> version ("" means latest)
      pypi_packages = var.pypi_packages
    }
 
    # Overall sizing hint; workloads_config sets per-component reservations
    environment_size = var.environment_size
 
    # Workload reservations (Composer 2 supports these)
    workloads_config {
      scheduler {
        cpu        = 2
        memory_gb  = 4
        storage_gb = 20
        count      = 1
      }
 
      web_server {
        cpu        = 2
        memory_gb  = 4
        storage_gb = 20
      }
 
      worker {
        cpu        = 2
        memory_gb  = 4
        storage_gb = 20
        min_count  = 1
        max_count  = 3
      }
    }
  }
}