resource "google_cloudfunctions2_function" "function" {
  name     = var.name
  location = var.region
 
  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point
 
    source {
      storage_source {
        bucket = var.source_bucket
        object = var.source_object
      }
    }
  }
 
  service_config {
    max_instance_count    = 3
    available_memory      = "256M"
    timeout_seconds       = 60
    ingress_settings      = "ALLOW_ALL"
  }
 
  labels = var.labels
}
 
resource "google_cloud_run_service_iam_member" "invoker" {
  location = var.region
  service  = google_cloudfunctions2_function.function.service_config[0].service
  role     = "roles/run.invoker"
  member   = "allUsers"
}