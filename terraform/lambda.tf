resource "aws_lambda_function" "trigger_glue_etl" {
  function_name = "trigger-glue-etl-${var.environment}"  # 1. Add environment suffix
  role          = aws_iam_role.dms_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 60                                     # 2. Add explicit timeout
  memory_size   = 128                                    # 3. Specify memory size

  filename         = "${path.module}/lambda/lambda_function.zip"  # 4. Use path.module
  source_code_hash = filebase64sha256("${path.module}/lambda/lambda_function.zip")

  environment {
    variables = {
      GLUE_JOB_NAME = aws_glue_job.convert_to_parquet.name
      ENVIRONMENT   = var.environment                     # 5. Add environment variable
    }
  }

  tracing_config {                                        # 6. Add tracing
    mode = "Active"
  }

  depends_on = [aws_iam_role.dms_role]                   # 7. Add explicit dependency
}