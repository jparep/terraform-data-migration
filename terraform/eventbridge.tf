# Variables (define these in variables.tf or pass them in)
variable "lambda_arn" {}  # ARN of the Lambda function triggering the Glue job
variable "s3_bucket_name" { default = "vital-health-migration" }  # Your S3 bucket

# Scheduled Rule: Triggers Glue job every 6 hours via Lambda
resource "aws_cloudwatch_event_rule" "glue_schedule" {
  name                = "glue-job-schedule"
  description         = "Triggers Glue ETL job every 6 hours"
  schedule_expression = "rate(6 hours)"
  is_enabled          = true

  tags = {
    Name = "glue-schedule"
  }
}

# Target for Scheduled Rule
resource "aws_cloudwatch_event_target" "glue_schedule_target" {
  rule      = aws_cloudwatch_event_rule.glue_schedule.name
  target_id = "GlueJobScheduleTrigger"
  arn       = var.lambda_arn  # References the Lambda function ARN
}

# Permission for Lambda Invocation (Scheduled Rule)
resource "aws_lambda_permission" "allow_cloudwatch_schedule" {
  statement_id  = "AllowExecutionFromCloudWatchSchedule"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.glue_schedule.arn
}

# S3 Event Rule: Triggers on object creation in a specific bucket
resource "aws_cloudwatch_event_rule" "s3_event_trigger" {
  name        = "s3-glue-job-trigger"
  description = "Triggers Glue job on S3 object creation"
  event_pattern = jsonencode({
    "source": ["aws.s3"],
    "detail-type": ["Object Created"],
    "detail": {
      "bucket": {
        "name": [var.s3_bucket_name]
      },
      "object": {
        "key": [{
          "prefix": "input/"  # Customize prefix as needed
        }]
      }
    }
  })
  is_enabled = true

  tags = {
    Name = "s3-event-trigger"
  }
}

# Target for S3 Event Rule (assuming same Lambda)
resource "aws_cloudwatch_event_target" "s3_event_target" {
  rule      = aws_cloudwatch_event_rule.s3_event_trigger.name
  target_id = "GlueJobS3Trigger"
  arn       = var.lambda_arn
}

# Permission for Lambda Invocation (S3 Event Rule)
resource "aws_lambda_permission" "allow_cloudwatch_s3" {
  statement_id  = "AllowExecutionFromCloudWatchS3"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_event_trigger.arn
}