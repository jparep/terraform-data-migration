output "instance_id" {
    description = "The ID of the instance"
    value       = aws_instance.example.id
}

output "instance_public_ip" {
    description = "The public IP of the instance"
    value       = aws_instance.example.public_ip
}

output "db_instance_endpoint" {
    description = "The endpoint of the RDS instance"
    value       = aws_db_instance.example.endpoint
}

output "s3_bucket_name" {
    description = "The name of the S3 bucket"
    value       = aws_s3_bucket.example.bucket
}