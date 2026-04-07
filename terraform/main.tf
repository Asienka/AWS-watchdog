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
output "ecr_repository_url" {
    description = "Repository URL for the ECR repository"
    value = aws_ecr_repository.url-monitoring-repository.repository_url  
}
output "topic_arn" {
    description = "ARN for the SNS topic"
    value = aws_sns_topic.url-monitor-alerts.arn
}