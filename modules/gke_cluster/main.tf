resource "google_container_cluster" "cluster" {
  name               = var.name
  project            = var.project_id
  location           = var.location
  deletion_protection = false

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # 👇 add this
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}

resource "google_container_node_pool" "primary_pool" {
  name       = var.node_pool_name
  project    = var.project_id
  cluster    = google_container_cluster.cluster.name
  location   = var.location

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    metadata     = { disable-legacy-endpoints = "true" }
    labels       = { "cluster" = var.name, "pool" = var.node_pool_name }
  }

  autoscaling {
    min_node_count = var.min_nodes
    max_node_count = var.max_nodes
  }

  initial_node_count = var.min_nodes
}