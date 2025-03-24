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
├── terraform/                    # Terraform configuration files
│   ├── main.tf                   # Core infrastructure definitions
│   ├── variables.tf              # Configurable variables with validation
│   ├── outputs.tf                # Resource outputs (e.g., S3 bucket ARN)
│   ├── provider.tf               # AWS provider and backend configuration
│   ├── modules/                  # Modularized Terraform configurations
│   │   ├── dms/                  # DMS module (source → target)
│   │   ├── glue/                 # Glue ETL module
│   │   ├── lambda/               # Lambda automation module
│   │   ├── s3/                   # S3 storage module
│   │   └── eventbridge/          # Scheduling module
│   ├── iam.tf                    # IAM roles and policies (Added)
│   └── snowflake.tf              # Snowflake integration (Added)
├── glue-scripts/                 # AWS Glue ETL scripts
│   └── convert_to_parquet.py     # Python script for CSV → Parquet conversion
├── lambda/                       # AWS Lambda functions
│   └── trigger_glue_job.py       # Renamed for clarity: Triggers Glue jobs
├── tests/                        # Added: Integration tests directory
│   └── test_deployment.tf        # Terraform test configurations
├── .gitignore                    # Git ignore file
├── .terraform.lock.hcl           # Added: Dependency lock file
└── README.md                     # Enhanced deployment documentation
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
```

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

#### cAutomating Data Processing
Trigger AWS Glue Job

aws glue start-job-run --job-name convert_to_parquet

#### Clean Up Resources

To destroy all AWS resources, run:

terraform destroy -auto-approve

### License