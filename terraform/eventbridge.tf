resource "aws_cloudwatch_event_rule" "glue_schedule" {
  name                = "glue-job-schedule"
  schedule_expression = "rate(6 hours)"
}

resource "aws_cloudwatch_event_target" "glue_trigger" {
  rule      = aws_cloudwatch_event_rule.glue_schedule.name
  target_id = "GlueJobTrigger"
  arn       = aws_lambda_function.trigger_glue_etl.arn
}
