# Variables (define these in variables.tf or pass them in)
variable "glue_role_arn" {}  # ARN of the IAM role for Glue
variable "s3_bucket_name" { default = "vital-health-migration" }  # Your S3 bucket

# Glue Job
resource "aws_glue_job" "convert_to_parquet" {
  name         = "convert-to-parquet"  # Hyphenated for consistency with AWS naming conventions
  description  = "Converts CSV data to Parquet format"
  role_arn     = var.glue_role_arn
  glue_version = "3.0"  # Modern Glue version supporting Python 3

  command {
    script_location = "s3://${var.s3_bucket_name}/scripts/convert_to_parquet.py"
    python_version  = "3"
  }

  execution_property {
    max_concurrent_runs = 2  # Allows parallel runs if triggered multiple times
  }

  default_arguments = {
    "--job-language"         = "python"
    "--TempDir"              = "s3://${var.s3_bucket_name}/temp/"  # Temporary storage
    "--INPUT_PATH"           = "s3://${var.s3_bucket_name}/input/"  # From your earlier script
    "--OUTPUT_PATH"          = "s3://${var.s3_bucket_name}/parquet/"  # From your earlier script
    "--enable-metrics"       = "true"  # Enable CloudWatch metrics
    "--enable-spark-ui"      = "true"  # Enable Spark UI for debugging
    "--spark-event-logs-path" = "s3://${var.s3_bucket_name}/spark-logs/"  # Spark logs
  }

  worker_type       = "G.1X"  # Standard worker type; adjust based on workload
  number_of_workers = 2       # Minimum for small jobs; scale up for larger datasets
  max_retries       = 1       # Retry once on failure
  timeout           = 60      # 60 minutes timeout; adjust as needed

  tags = {
    Name        = "convert-to-parquet"
    Environment = "production"
  }
}

# Example IAM Role for Glue (if not already defined)
resource "aws_iam_role" "glue_role" {
  name = "glue-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "glue.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "glue_policy" {
  role = aws_iam_role.glue_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["glue:*", "logs:*"]
        Resource = ["*"]
      }
    ]
  })
}