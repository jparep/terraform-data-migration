# 📌 Vital Health Database Migration to AWS S3 Using Terraform

## 🚀 Overview
This project **automates** the migration of **on-premise PostgreSQL (`vital_health_db`)** to **AWS S3** using **Terraform**. The data is extracted using **AWS Database Migration Service (DMS)**, transformed to **Parquet format using AWS Glue**, and stored in **Snowflake for analytics**.

This setup ensures:
✅ **Cost-effectiveness** (Optimized S3 storage with Parquet)  
✅ **Security** (IAM roles, S3 encryption, AWS Secrets Manager)  
✅ **Scalability** (Terraform-managed, AWS auto-scaling)  
✅ **Automation** (Lambda & EventBridge trigger Glue jobs)  

---

## 📂 Project Structure


---

## 🛠️ Prerequisites
Before deploying, ensure you have:
- **Terraform v1.4+** installed → [Download Terraform](https://www.terraform.io/downloads)
- **AWS CLI** configured → `aws configure`
- **Access to AWS S3, DMS, Glue, Lambda, and IAM**
- **An existing on-prem PostgreSQL database**

---

## 📌 1️⃣ Setup & Configuration

### **1. Clone the Repository**
```sh
git clone https://github.com/jparep/terraform-data-migration.git
cd vital_health_migration

