resource "aws_lambda_function" "trigger_glue_etl" {
  function_name = "trigger-glue-etl"
  role          = aws_iam_role.dms_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename      = "lambda/lambda_function.zip"
  source_code_hash = filebase64sha256("lambda/lambda_function.zip")

  environment {
    variables = {
      GLUE_JOB_NAME = aws_glue_job.convert_to_parquet.name
    }
  }
}
