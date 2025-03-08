# Variables (ensure these are defined in variables.tf or passed in)
variable "dms_instance_class" { default = "dms.t3.medium" }  # More suitable for production
variable "postgres_username" {}
variable "postgres_password" { sensitive = true }
variable "postgres_host" {}
variable "postgres_port" { default = 5432 }
variable "postgres_db" {}

# S3 Bucket (assumed from your reference)
resource "aws_s3_bucket" "dms_s3_bucket" {
  bucket = "vital-health-dms-bucket"
  # Add versioning, lifecycle rules, etc., as needed
}

# DMS Replication Instance
resource "aws_dms_replication_instance" "dms_instance" {
  replication_instance_id     = "vital-health-dms-instance"
  replication_instance_class  = var.dms_instance_class
  allocated_storage           = 100  # Adjust based on data size
  apply_immediately           = true
  publicly_accessible         = false
  multi_az                    = false  # Set to true for HA in production
  vpc_security_group_ids      = [aws_security_group.dms_sg.id]  # Define this separately
  replication_subnet_group_id = aws_dms_replication_subnet_group.dms_subnet_group.id  # Define this separately

  tags = {
    Name = "vital-health-dms"
  }
}

# DMS Subnet Group (example)
resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_id          = "dms-subnet-group"
  replication_subnet_group_description = "Subnet group for DMS"
  subnet_ids                           = ["subnet-123", "subnet-456"]  # Replace with your subnet IDs
}

# Security Group (example)
resource "aws_security_group" "dms_sg" {
  name        = "dms-security-group"
  description = "Security group for DMS"
  vpc_id      = "vpc-123"  # Replace with your VPC ID

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]  # Restrict to your VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# PostgreSQL Source Endpoint
resource "aws_dms_endpoint" "postgres_source" {
  endpoint_id   = "postgres-source"
  endpoint_type = "source"
  engine_name   = "postgres"
  username      = var.postgres_username
  password      = var.postgres_password
  server_name   = var.postgres_host
  port          = var.postgres_port
  database_name = var.postgres_db

  tags = {
    Name = "postgres-source"
  }
}

# S3 Target Endpoint
resource "aws_dms_endpoint" "s3_target" {
  endpoint_id   = "s3-target"
  endpoint_type = "target"
  engine_name   = "s3"
  s3_settings {
    bucket_name          = aws_s3_bucket.dms_s3_bucket.bucket
    encryption_mode      = "SSE_S3"
    service_access_role_arn = aws_iam_role.dms_s3_role.arn  # Define this separately
    csv_row_delimiter    = "\\n"
    csv_delimiter        = ","
  }

  tags = {
    Name = "s3-target"
  }
}

# IAM Role for S3 Access (example)
resource "aws_iam_role" "dms_s3_role" {
  name = "dms-s3-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "dms.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "d