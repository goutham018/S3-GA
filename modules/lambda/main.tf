variable "bucket_name" {
  type = string
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_execution_role-12345"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_lambda_function" "ci_failure_log_processor" {
  function_name = "ciFailureLogProcessor"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "handler.main"
  filename      = "./modules/lambda/lambda_function/lambda.zip"
}

resource "aws_lambda_permission" "allow_s3_invocation" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ci_failure_log_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_name}"
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_exec.arn
}

output "lambda_function_arn" {
  value = aws_lambda_function.ci_failure_log_processor.arn
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the Lambda function"
  default     = {}
}

