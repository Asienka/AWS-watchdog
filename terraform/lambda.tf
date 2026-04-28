resource "aws_lambda_function" "url_monitor" {
  function_name = "url-monitoring-lambda"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = var.ecr_image_uri
  architectures = ["x86_64"]
  publish = true

  environment {
    variables = {

      TARGET_URL    = var.lambda_target_url
      SNS_TOPIC_ARN = aws_sns_topic.url_monitor_alerts.arn
    }
  }
  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory
}
resource "aws_lambda_alias" "live" {
  name             = "live version"
  function_name    = aws_lambda_function.url_monitor.function_name
  function_version = aws_lambda_function.url_monitor.version
  
}