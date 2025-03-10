resource "aws_s3_bucket" "dms_s3_bucket" {
  bucket = var.s3_bucket_name
  
  # Added recommended security best practices
  force_destroy = false  # Prevents accidental deletion of bucket with contents
  tags = {
    Name        = var.s3_bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.dms_s3_bucket.id  # Using .id is more explicit than .bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"  # Consider using KMS instead of AES256 for better key management
      # kms_master_key_id = aws_kms_key.example.arn  # Uncomment and configure if using KMS
    }
  }
}

# Additional recommended configurations
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.dms_s3_bucket.id
  versioning_configuration {
    status = "Enabled"  # Enables versioning for data protection
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.dms_s3_bucket.id
  
  # Security best practices
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}