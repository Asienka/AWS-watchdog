terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>6.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "url-monitoring-repository" {
    name = "url-monitoring-repository"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
        scan_on_push = true
          } 
}

resource "aws_sns_topic" "url-monitor-alerts" {
    name = "url-monitor-alerts"  
}
resource "aws_sns_topic_subscription" "email_alert" {
    topic_arn = aws_sns_topic.url-monitor-alerts.arn
    protocol = "email"
    endpoint = "ulanowska.joanna@gmail.com"

}
resource "aws_iam_role" "lambda_role" {
    name = "url_monitor_lambda_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Effect = "Allow",
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy" "lambda_policy" {
    name = "url_monitor_lambda_policy"
    role = aws_iam_role.lambda_role.id
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                Resource = "arn:aws:logs:*:*:*"
            },
            {
                Effect = "Allow",
                Action = [
                    "sns:Publish"
                ],
                Resource = aws_sns_topic.url-monitor-alerts.arn
            }
        ]
    })
  
}
resource "aws_lambda_function" "url_monitor" {
  function_name = "url-monitoring-lambda"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.url-monitoring-repository.repository_url}:latest"
  architectures = ["x86_64"]
  

  environment {
    variables = {
      TARGET_URL    = "https://www.google.com" # Tu możesz wpisać co chcesz monitorować
      SNS_TOPIC_ARN = aws_sns_topic.url-monitor-alerts.arn
    }
  }

  timeout     = 10 # Lambda ma 10 sekund na sprawdzenie URL
  memory_size = 128
}

output "ecr_repository_url" {
    description = "Repository URL for the ECR repository"
    value = aws_ecr_repository.url-monitoring-repository.repository_url  
}
output "topic_arn" {
    description = "ARN for the SNS topic"
    value = aws_sns_topic.url-monitor-alerts.arn
}