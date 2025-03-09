provider "aws" {
    region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
    bucket = "example-bucket"
    acl    = "private"
}

resource "aws_dynamodb_table" "example" {
    name           = "example-table"
    billing_mode   = "PAY_PER_REQUEST"
    hash_key       = "id"

    attribute {
        name = "id"
        type = "S"
    }
}

output "s3_bucket_name" {
    value = aws_s3_bucket.example.bucket
}

output "dynamodb_table_name" {
    value = aws_dynamodb_table.example.name
}