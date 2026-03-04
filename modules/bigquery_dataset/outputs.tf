output "dataset_id" {
  description = "The ID of the created BigQuery dataset"
  value       = google_bigquery_dataset.dataset.dataset_id
}

output "dataset_self_link" {
  description = "Self link of the dataset"
  value       = google_bigquery_dataset.dataset.self_link
}