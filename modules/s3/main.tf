variable "bucket_name" {
  type = string
}

resource "aws_s3_bucket" "ci_failure_logs" {
  bucket = var.bucket_name
}

output "bucket_name" {
  value = aws_s3_bucket.ci_failure_logs.id
}
