resource "google_bigquery_dataset" "dataset" {
  project                      = var.project_id
  dataset_id                   = var.dataset_id
  location                     = var.location
  labels                       = var.labels
  default_table_expiration_ms  = var.default_table_expiration_ms
}