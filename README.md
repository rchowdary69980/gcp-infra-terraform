README.md — GCP Infrastructure Automation using Terraform & Python

Introduction
This project is about building and automating GCP infrastructure using Terraform modules and a Python script.
I created separate Terraform modules for each major GCP service so that everything is clean, reusable, and easy to manage.
The services I worked with are:
•	GCS Bucket
•	BigQuery Dataset
•	Cloud Function (Infrastructure Only)
•	GKE Cluster
•	Cloud Composer Environment
•	A Python automation script for creating a bucket
The idea behind the project was to understand how cloud resources work, how Terraform modules can simplify infrastructure, and how Python can automate basic tasks.
Throughout this assignment, I focused on keeping things modular, readable, and following best practices used in real world DevOps teams.
________________________________________
Project Structure
gcp-infra-terraform/
│
├── modules/
│   ├── gcs_bucket/
│   ├── bigquery_dataset/
│   ├── cloud_function_v2/
│   ├── gke_cluster/
│   └── cloud_composer_v2/
│
├── envs/
│   └── dev/
│       ├── main.tf
│       ├── providers.tf
│       ├── versions.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── backend.tf
│
└── scripts/
      └── app.py
Each module is reusable and parameterized.
The envs/dev folder acts as the environment where I combine all modules to deploy the entire stack.
________________________________________
1. GCS Bucket
What I Understood
A GCS bucket is Google Cloud’s object storage. It is used to store files like logs, backups, artifacts, Cloud Function code, and even Terraform remote state.
I learned that bucket names must be globally unique and that enabling versioning helps recover overwritten files.
Why We Need It
Most cloud systems rely on buckets:
•	Cloud Functions need a bucket to store deployment code
•	BigQuery uses buckets to load CSV/JSON/Parquet data
•	CI/CD pipelines push artifacts here
•	Applications may store uploaded content
So provisioning a bucket first is important in most GCP deployments.
How I Ran It
cd envs/dev
terraform init
terraform apply -target="module.gcs_bucket"
Then I checked the bucket in the Cloud Console under Storage.
________________________________________
2. BigQuery Dataset
What I Understood
A BigQuery dataset is like a “database schema.” It stores tables, views, and metadata. BigQuery itself is a serverless data warehouse used for analytics, reporting, and large SQL workloads.
Why We Need It
Datasets help in:
•	Organizing analytical data
•	Enforcing access control
•	Running ETL/ELT pipelines
•	Integrating with Dataflow or Cloud Functions
It becomes the foundation of any analytics system.
How I Ran It
terraform apply -target="module.bigquery_dataset"
I then verified it in the BigQuery UI under my project.
________________________________________
3. Cloud Function (Infrastructure Only)
What I Understood
Cloud Functions Gen2 is a serverless compute service.
Gen2 uses Cloud Run under the hood, which gives better scaling and performance.
In this assignment, I only created the infrastructure, not the actual function code. The module provisions:
•	runtime
•	region
•	service account
•	the Cloud Function resource itself
•	the bucket that holds the function source
Why We Need It
Cloud Functions are used for lightweight tasks and event-driven workflows such as notifications, image processing, triggers from GCS, etc. Gen2 makes it more powerful.
How I Ran It
terraform apply -target="module.cloud_function"
Then I checked it in the Cloud Functions console.
________________________________________
4. GKE Cluster
What I Understood
GKE is Google’s managed Kubernetes service.
This was the most complex part of the assignment. I learned:
•	GKE needs a VPC, subnet, and secondary ranges for Pods and Services
•	Node pools define machine types and scaling
•	Zonal clusters are fine for dev; regional clusters offer high availability
•	Workload Identity is the recommended way to link GCP IAM with Kubernetes
This cluster allows running containerized applications at scale.
Why We Need It
Modern applications often run on Kubernetes, so provisioning a GKE cluster using Terraform teaches how to manage infrastructure for containerized workloads.
How I Ran It
terraform apply -target="module.gke_cluster"
I verified it in the GKE dashboard.
________________________________________
5. Cloud Composer Environment
What I Understood
Cloud Composer is Google’s managed Airflow workflow service.
It is mainly used for data pipelines, scheduled tasks, and orchestrating GCP services like BigQuery, Dataflow, and Cloud Storage.
While working on this, I learned:
•	Composer v2 is built on GKE Autopilot
•	It requires a dedicated service account
•	Environment creation takes longer (20–40 minutes)
•	Composer creates its own GCS DAG bucket automatically
Why We Need It
Data orchestration is essential in data engineering. Composer helps manage complex workflows without maintaining Airflow manually.
How I Ran It
terraform apply -target="module.composer"
After creation, I accessed the Airflow UI through the Composer environment link.
________________________________________
6. Python Automation Script
What I Understood
The script (app.py) automates GCS bucket creation using Python.
It uses PowerShell commands internally to execute:
•	gcloud to set the project
•	gcloud to enable the Storage API
•	gsutil to create a bucket and enable versioning
This helps automate tasks that developers or DevOps engineers might frequently perform manually.
Why We Need It
This script shows I understand:
•	How to automate cloud operations
•	How to interact with GCP tools via Python
•	How to safely run shell commands and handle outputs
How I Ran It
python scripts/app.py --project <PROJECT_ID> --region asia-south1 --bucket my-bucket-123
________________________________________
How to Deploy the Full Infrastructure
Step 1: Go to environment directory
cd envs/dev
Step 2: Initialize Terraform
terraform init
Step 3: Preview
terraform plan
Step 4: Apply
terraform apply
Step 5: Destroy (optional)
terraform destroy
________________________________________
What I Learned from This Project
•	How different GCP services work and depend on each other
•	How to build reusable Terraform modules
•	How to structure cloud projects into modules and environments
•	The importance of networking (especially for GKE and Composer)
•	How service accounts and IAM tie everything together
•	How to automate simple tasks using Python
•	How to follow IaC best practices
•	How to push clean code using .gitignore
•	How to troubleshoot real-world cloud issues
________________________________________
Conclusion
This project helped me understand both Terraform module design and how core GCP services fit together. By separating everything into modules and adding Python automation, I created a clear, reusable, and practical infrastructure setup that can be extended further in the future.
