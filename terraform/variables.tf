variable "aws_region" { default = "us-east-1" }
variable "s3_bucket_name" { default = "vital-health-migration" }
variable "postgres_host" { default = "onprem-server" }
variable "postgres_port" { default = "5432" }
variable "postgres_db" { default = "vital_health_db" }
variable "postgres_username" { default = "dbuser" }
variable "postgres_password" { default = "mypassword" }
variable "dms_instance_class" { default = "dms.r5.large" }
