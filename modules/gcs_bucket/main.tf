resource "google_storage_bucket" "bucket" {
  project       = var.project_id
  name          = var.name
  location      = var.location
  storage_class = var.storage_class
  labels        = var.labels

  uniform_bucket_level_access = var.ubla
  force_destroy               = var.force_destroy

  versioning {
    enabled = var.versioning
  }
 
}