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
