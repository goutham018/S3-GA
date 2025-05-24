variable "bucket_name" {
  type = string
}

resource "aws_s3_bucket" "ci_failure_logs" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_notification" "notify_lambda" {
  bucket = aws_s3_bucket.ci_failure_logs.id

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    # filter_prefix       = ""    # Optional: Add if you want to restrict to a folder
    # filter_suffix       = ".log" # Optional: Restrict to specific file types
  }

  depends_on = [aws_s3_bucket.ci_failure_logs]
}


output "bucket_name" {
  value = aws_s3_bucket.ci_failure_logs.id
}
