resource "aws_ecr_repository" "url_monitoring_repository" {
  name                 = "url-monitoring-repository"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_sns_topic" "url_monitor_alerts" {
  name = "url-monitor-alerts"
}
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.url_monitor_alerts.arn
  protocol  = "email"
  endpoint  = var.sns_alert_email

}

resource "aws_ecr_lifecycle_policy" "main_policy" {
  repository = aws_ecr_repository.url_monitoring_repository.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep only the 5 most recent images to save space"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = {
        type = "expire"
      }
    }]
  })
}



