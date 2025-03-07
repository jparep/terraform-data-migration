resource "aws_dms_replication_instance" "dms_instance" {
  replication_instance_id   = "vital-health-dms-instance"
  replication_instance_class = var.dms_instance_class
  allocated_storage         = 100
  publicly_accessible       = false
}

resource "aws_dms_endpoint" "postgres_source" {
  endpoint_id     = "postgres-source"
  endpoint_type   = "source"
  engine_name     = "postgres"
  username        = var.postgres_username
  password        = var.postgres_password
  server_name     = var.postgres_host
  port            = var.postgres_port
  database_name   = var.postgres_db
}

resource "aws_dms_endpoint" "s3_target" {
  endpoint_id     = "s3-target"
  endpoint_type   = "target"
  engine_name     = "s3"
  s3_settings {
    bucket_name = aws_s3_bucket.dms_s3_bucket.bucket
    encryption_mode = "SSE_S3"
  }
}

resource "aws_dms_replication_task" "dms_task" {
  replication_task_id   = "postgres-to-s3"
  migration_type        = "full-load-and-cdc"
  source_endpoint_arn   = aws_dms_endpoint.postgres_source.endpoint_arn
  target_endpoint_arn   = aws_dms_endpoint.s3_target.endpoint_arn
  replication_instance_arn = aws_dms_replication_instance.dms_instance.replication_instance_arn
}


# Placeholder for AWS DMS (Database Migration Service) configuration
resource "aws_dms_replication_instance" "dms_instance" {
  replication_instance_class = "dms.t2.micro"
  allocated_storage         = 20
  apply_immediately         = true
  # Add additional DMS configurations as needed
}