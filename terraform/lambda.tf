resource "aws_lambda_function" "url_monitor" {
  function_name = "url-monitoring-lambda"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = var.ecr_image_uri
  architectures = ["x86_64"]
  publish       = true

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
  name             = "live"
  function_name    = aws_lambda_function.url_monitor.function_name
  function_version = aws_lambda_function.url_monitor.version

}
resource "aws_lambda_permission" "sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.url_monitor.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.url_monitor_alerts.arn
}

data "archive_file" "self_healer_zip" {
  type        = "zip"
  source_file = "${path.module}/../self_healer.py"
  output_path = "${path.module}/self_healer_function.zip"
}
resource "aws_lambda_function" "self_healer" {
  filename         = data.archive_file.self_healer_zip.output_path
  function_name    = "url-monitor-self-healer"
  role             = aws_iam_role.lambda_role.arn
  handler          = "self_healer.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.self_healer_zip.output_base64sha256

  environment {
    variables = {
      LAMBDA_FUNCTION_NAME = aws_lambda_function.url_monitor.function_name
    }
  }
}
resource "aws_lambda_permission" "sns_invoke_self_healer" {
  statement_id  = "AllowExecutionFromSNSSelfHealer"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.self_healer.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.url_monitor_alerts.arn
}