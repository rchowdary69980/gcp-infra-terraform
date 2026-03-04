output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.cluster.name
}

output "endpoint" {
  description = "GKE control plane endpoint"
  value       = google_container_cluster.cluster.endpoint
}

output "ca_certificate" {
  description = "Cluster CA certificate (base64)"
  value       = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
}