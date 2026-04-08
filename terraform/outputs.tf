output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.url_monitoring_repository.repository_url
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.url_monitor_alerts.arn
}