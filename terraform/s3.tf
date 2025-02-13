resource "aws_s3_bucket" "dms_s3_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.dms_s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
