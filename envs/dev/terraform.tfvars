project_id = "project-0353a607-51f8-47be-8e2"
region     = "asia-south1"



source_bucket  = "9988-bucket"
source_object  = "source.zip" 


composer_name     = "composer-demo"
service_account_id = "composer-demo-sa"
 
network    = "default"
subnetwork = "default"
 
image_version = "composer-3-airflow-3.1.0"
 
env_variables = {
  ENV = "dev"
}
 
pypi_packages = {
  pandas  = ""
  requests = ""
}