variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy resources in"
  
  validation {
    condition     = can(regex("^us-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "AWS region must be a valid US region format (e.g., us-east-1)"
  }
}

variable "s3_bucket_name" {
  type        = string
  default     = "vital-health-migration"
  description = "Name of the S3 bucket for migration data"
  
  validation {
    condition     = length(var.s3_bucket_name) >= 3 && length(var.s3_bucket_name) <= 63
    error_message = "S3 bucket name must be between 3 and 63 characters"
  }
}

variable "postgres_host" {
  type        = string
  default     = "onprem-server"
  description = "Hostname of the PostgreSQL server"
}

variable "postgres_port" {
  type        = number
  default     = 5432
  description = "Port number for PostgreSQL connection"
  
  validation {
    condition     = var.postgres_port >= 1024 && var.postgres_port <= 65535
    error_message = "Port number must be between 1024 and 65535"
  }
}

variable "postgres_db" {
  type        = string
  default     = "vital_health_db"
  description = "Name of the PostgreSQL database"
}

variable "postgres_username" {
  type        = string
  default     = "dbuser"
  description = "Username for PostgreSQL authentication"
}

variable "postgres_password" {
  type        = string
  description = "Password for PostgreSQL authentication"
  sensitive   = true
  # Removed default value - should not be hardcoded
}

variable "dms_instance_class" {
  type        = string
  default     = "dms.r5.large"
  description = "AWS DMS instance class"
  
  validation {
    condition     = can(regex("^dms\\.[a-z0-9]+\\.[a-z]+$", var.dms_instance_class))
    error_message = "Must be a valid DMS instance class (e.g., dms.r5.large)"
  }
}