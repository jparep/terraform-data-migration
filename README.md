# Vital Health Database Migration to AWS S3 Using Terraform

## Overview
This project **automates** the migration of **on-premise PostgreSQL (`vital_health_db`)** to **AWS S3** using **Terraform**. The data is extracted using **AWS Database Migration Service (DMS)**, transformed to **Parquet format using AWS Glue**, and stored in **Snowflake for analytics**.

This setup ensures:
✅ **Cost-effectiveness** (Optimized S3 storage with Parquet)  
✅ **Security** (IAM roles, S3 encryption, AWS Secrets Manager)  
✅ **Scalability** (Terraform-managed, AWS auto-scaling)  
✅ **Automation** (Lambda & EventBridge trigger Glue jobs)  

---

# Project File Structure: Vital Health Data Migration to AWS

This file structure represents the **Terraform-based AWS infrastructure** for migrating **on-premise PostgreSQL** (`vital_health_db`) to **AWS S3**, processing it with **AWS Glue**, and integrating it with **Snowflake for analytics**.

```bash
vital_health_migration/
│── terraform/                   # Terraform configuration directory
│   ├── main.tf                   # Terraform main infrastructure setup
│   ├── variables.tf               # User-defined variables for easy configuration
│   ├── outputs.tf                 # Outputs for AWS resources
│   ├── provider.tf                # AWS provider configuration
│   ├── dms.tf                     # AWS DMS configuration (Database Migration Service)
│   ├── glue.tf                    # AWS Glue job setup (ETL for Parquet)
│   ├── lambda.tf                  # AWS Lambda function for automation
│   ├── s3.tf                      # AWS S3 bucket for storing exported data
│   ├── eventbridge.tf             # AWS EventBridge setup for scheduling jobs
│── glue-scripts/                  # AWS Glue ETL scripts directory
│   ├── convert_to_parquet.py       # Python script for AWS Glue (CSV to Parquet)
│── lambda/                         # AWS Lambda functions directory
│   ├── lambda_function.py          # Python script for AWS Lambda (Triggers Glue jobs)
│── .gitignore                      # Ignore Terraform state files & AWS credentials
│── README.md                       # Documentation for deployment steps
```

---

## Prerequisites
Before deploying, ensure you have:
- **Terraform v1.4+** installed → [Download Terraform](https://www.terraform.io/downloads)
- **AWS CLI** configured → `aws configure`
- **Access to AWS S3, DMS, Glue, Lambda, and IAM**
- **An existing on-prem PostgreSQL database**

---

## Setup & Configuration

### **1. Clone the Repository**
```sh
git clone https://github.com/jparep/terraform-data-migration.git
cd vital_health_migration


###  Deployment Steps

1. **Initialize Terraform**
    ```sh
    terraform init
    ```

2. **Plan Deployment**
    ```sh
    terraform plan
    ```

3. **Apply Terraform**
    ```sh
    terraform apply -auto-approve
    ```
