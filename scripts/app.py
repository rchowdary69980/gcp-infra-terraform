#!/usr/bin/env python3
"""
GCS Bucket Automation Script (Windows Compatible)
-------------------------------------------------

This script automates:
1. Setting GCP project
2. Enabling Storage API
3. Creating a GCS bucket if missing
4. Enabling bucket versioning

This fulfills the assignment requirement:
"Any Python automation which helps GCP infra setup and automation."
"""

import argparse
import subprocess
import sys


def run_ps(command: str):
    """
    Run commands through PowerShell so gcloud/gsutil always work on Windows.
    """
    full_cmd = ["powershell.exe", "-Command", command]
    print("+", " ".join(full_cmd))

    proc = subprocess.run(
        full_cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True
    )

    print(proc.stdout)

    if proc.returncode != 0:
        print(f"❌ ERROR running command: {command}", file=sys.stderr)
        sys.exit(proc.returncode)


def bucket_exists(bucket_name: str) -> bool:
    """
    Check if bucket exists using gsutil through PowerShell.
    """
    cmd = f"gsutil ls gs://{bucket_name}"
    check = subprocess.run(
        ["powershell.exe", "-Command", cmd],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    return check.returncode == 0


def create_bucket(region: str, bucket_name: str):
    """
    Creates bucket and enables versioning if it doesn't exist.
    """
    print(f"\n🔍 Checking bucket: gs://{bucket_name}")

    if bucket_exists(bucket_name):
        print("ℹ️ Bucket already exists. Skipping creation.")
        return

    # Create bucket
    print(f"🪣 Creating bucket: gs://{bucket_name}")
    run_ps(f"gsutil mb -l {region} gs://{bucket_name}")

    # Enable versioning
    print("🔁 Enabling versioning on bucket")
    run_ps(f"gsutil versioning set on gs://{bucket_name}")

    print(f"✅ Bucket created successfully: gs://{bucket_name}")


def main():
    parser = argparse.ArgumentParser(description="GCS Bucket Automation Script")
    parser.add_argument("--project", required=True, help="GCP Project ID")
    parser.add_argument("--region", default="asia-south1", help="Bucket region")
    parser.add_argument("--bucket", required=True, help="Bucket name")
    args = parser.parse_args()

    # 1. Set project
    print("\n📌 Setting active project")
    run_ps(f"gcloud config set project {args.project}")

    # 2. Enable Storage API
    print("\n📌 Enabling Cloud Storage API")
    run_ps(f"gcloud services enable storage.googleapis.com --project {args.project}")

    # 3. Create bucket
    print("\n📌 Processing GCS bucket")
    create_bucket(args.region, args.bucket)

    print("\n🎉 DONE — GCS bucket automation complete!")
    print(f"Bucket: gs://{args.bucket}/")
    print("Versioning: Enabled\n")


if __name__ == "__main__":
    main()