output "bucket_name" {
  description = "Bucket name"
  value       = google_storage_bucket.bucket.name
}

output "bucket_url" {
  description = "gs:// URL"
  value       = "gs://${google_storage_bucket.bucket.name}"
}

