📘 README.md — GCP Infrastructure Automation using Terraform & Python

📘 Introduction
This project demonstrates end‑to‑end Google Cloud Platform (GCP) infrastructure provisioning using Terraform and supporting automation using Python.




The assignment required building reusable Terraform modules for the following GCP services:

GCS Bucket
BigQuery Dataset
Cloud Function (Infrastructure Only)
GKE Cluster
Cloud Composer Environment
Python automation that helps with GCP infra setup

To satisfy these requirements, I designed a clean, modular Terraform structure where each GCP service is implemented as its own reusable module with clearly defined variables, outputs, best practices, and infrastructure logic.
A simple main.tf file inside envs/dev composes all modules together, demonstrating how these resources can be deployed consistently into a real GCP project.
In addition to Terraform, the project also includes a Python automation script that prepares a GCP environment by creating a GCS bucket programmatically. This script shows my understanding of:

Using Python for cloud automation
Executing gcloud/gsutil commands safely
Automating foundational infrastructure tasks
Ensuring repeatable environment setup


🎯 Overall Objective
The primary objective of this work is to showcase:

Practical Terraform module development
Understanding of core GCP services
Clean and production‑grade IaC structure
Use of variables, outputs, and reusable modules
Automation mindset via Python scripting
Proper documentation and readability

Every resource is built from scratch with industry best practices in mind, focusing on modularity, security, scalability, and clarity — ensuring the infrastructure is easy to deploy, understand, and maintain.

🧠 What This Project Demonstrates
By completing this assignment, I showcase my understanding of:

How GCP resources work (purpose, inputs, dependencies)
How to design and structure Terraform modules
How to use Workload Identity, network ranges, node pools, and service accounts
How to automate infrastructure setup using Python
How to follow DevOps/IaC best practices
How to write clean, readable, and production‑oriented code
This project contains Terraform modules for provisioning key Google Cloud services and a Python automation script to streamline GCP setup activities.
The assignment required creating Terraform modules for:

GCS Bucket
BigQuery Dataset
Cloud Function (Infrastructure only)
GKE Cluster
Cloud Composer Environment
Python automation for GCP setup

Additionally, a main.tf combines these modules, and this README explains each resource, what it is used for, required inputs, and best practices.

📂 Project Structure
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
      └── app.py     # Python automation script

Each module is fully reusable, contains its own variables and outputs, and follows Terraform best practices.


🪣 GCS Bucket (Terraform Module)
📌 Understanding the Resource
A Google Cloud Storage (GCS) Bucket is Google Cloud’s fully‑managed object storage service.
It is used to store files such as:

Application artifacts
Cloud Function source zips
Logs
Backups
Infrastructure state files
Analytics data
Public or static assets

GCS provides durability, scalability, and global accessibility — making it a foundational service for almost every cloud workload.

🧠 Why This Resource Is Needed
Buckets are central to modern cloud infrastructure because:

Terraform or deployment pipelines often need an artifact repository
BigQuery external tables load data from GCS
Cloud Functions (Gen2) require their source code to be stored in GCS
GKE workloads may fetch config files or binaries from GCS
It provides universal, cost‑effective object storage

In short, almost every GCP architecture depends on at least one GCS bucket.

⚙️ Inputs & Why They Matter
Below are the key inputs your module requires — and the reasoning behind each one:
bucket_name

Must be globally unique across all of GCP.
Terraform cannot guess this; you must provide it explicitly.
Ensures safe identification of storage units.

location

Decides which region the bucket physically resides in.
Impacts:

Latency (closer to workloads = faster)
Cost
Compliance & data residency



Example: asia-south1 (Mumbai)
storage_class
Common options:

STANDARD → Frequently accessed
NEARLINE → Accessed monthly
COLDLINE → Accessed quarterly
ARCHIVE → Accessed annually

This affects cost and availability.
versioning

When enabled, GCS keeps all historical versions of objects.
Protects against:

Accidental deletion
Overwrites
Corruption



Strongly recommended for production workloads.
force_destroy

If set to true:

Terraform can delete the bucket even when objects exist.


Useful in development environments.
Not recommended for production.


📁 Terraform Module Structure
modules/gcs_bucket/main.tf
Terraformresource "google_storage_bucket" "bucket" {  name     = var.bucket_name  location = var.location  storage_class = var.storage_class  force_destroy = var.force_destroy  versioning {    enabled = var.versioning  }}Show more lines
modules/gcs_bucket/variables.tf
Terraformvariable "bucket_name"   { type = string }variable "location"      { type = string }variable "storage_class" {  type    = string  default = "STANDARD"}variable "versioning" {  type    = bool  default = true}variable "force_destroy" {  type    = bool  default = false}Show more lines
modules/gcs_bucket/outputs.tf
Terraformoutput "bucket_name" {  value = google_storage_bucket.bucket.name}Show more lines

📦 How to Use This Module (envs/dev/main.tf)
Terraformmodule "gcs_bucket" {  source        = "../../modules/gcs_bucket"  bucket_name   = "rahul-dev-bucket-12345"  location      = var.region  storage_class = "STANDARD"  versioning    = true  force_destroy = true}Show more lines

🔐 Best Practices
✔ Enable versioning
Prevents accidental loss of objects.
✔ Use least‑privilege IAM
Avoid ACLs; use IAM for access management.
✔ Use meaningful naming conventions
Example:
<project>-<env>-bucket
✔ Avoid force_destroy = true in production
Protect important data.
✔ Keep bucket region and workload region aligned
Reduces latency & egress costs.
✔ Use lifecycle rules
Automatically delete old logs or archives.

🏁 Summary
The GCS Bucket module:

Provides reusable, clean object storage provisioning
Supports Terraform automation
Enables versioning and force_destroy flags
Is aligned with GCP best practices
Is a foundational component consumed by other modules (Cloud Functions, BigQuery, etc.)

It is one of the simplest but most essential modules in your project.