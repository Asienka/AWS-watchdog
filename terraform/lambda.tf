resource "aws_lambda_function" "url_monitor" {
  function_name = "url-monitoring-lambda"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.url_monitoring_repository.repository_url}:latest"
  architectures = ["x86_64"]

  environment {
    variables = {
      
      TARGET_URL    = var.lambda_target_url 
      SNS_TOPIC_ARN = aws_sns_topic.url_monitor_alerts.arn
    }
  }
  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory
}