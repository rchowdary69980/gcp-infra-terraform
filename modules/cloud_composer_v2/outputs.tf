output "composer_airflow_uri" {
  value = google_composer_environment.composer_env.config[0].airflow_uri
}
 
output "composer_dag_bucket" {
  value = google_composer_environment.composer_env.config[0].dag_gcs_prefix
}
 
output "composer_service_account" {
  value = google_service_account.composer_sa.email
}