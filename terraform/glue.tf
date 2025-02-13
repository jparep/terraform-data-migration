resource "aws_glue_job" "convert_to_parquet" {
  name     = "convert_to_parquet"
  role_arn = aws_iam_role.dms_role.arn

  command {
    script_location = "s3://${aws_s3_bucket.dms_s3_bucket.bucket}/glue-scripts/convert_to_parquet.py"
  }
}
