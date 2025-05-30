provider "aws" {
  region = "us-east-1"
}

module "ci_log_bucket" {
  source = "./modules/s3"
  bucket_name = "ci-failure-logs-bucket-27355052"
  lambda_function_arn  = module.ci_log_lambda.lambda_function_arn
}

module "ci_log_lambda" {
  source          = "./modules/lambda"
  bucket_name     = module.ci_log_bucket.bucket_name
  # lambda_role_arn = module.ci_log_lambda.lambda_role_arn
environment_variables = {
    FASTAPI_URL = "http://13.203.102.146:8000/ci-logs"
  }
}
