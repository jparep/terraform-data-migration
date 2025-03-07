resource "aws_cloudwatch_event_rule" "glue_schedule" {
  name                = "glue-job-schedule"
  schedule_expression = "rate(6 hours)"
}

resource "aws_cloudwatch_event_target" "glue_trigger" {
  rule      = aws_cloudwatch_event_rule.glue_schedule.name
  target_id = "GlueJobTrigger"
  arn       = aws_lambda_function.trigger_glue_etl.arn
}

# Placeholder for AWS EventBridge configuration
resource "aws_cloudwatch_event_rule" "trigger_rule" {
  name        = "trigger-glue-job"
  description = "Triggers Glue job on S3 event"
  event_pattern = jsonencode({
    source = ["aws.s3"],
    detail-type = ["Object Created"]
  })
}