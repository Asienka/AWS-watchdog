moved {
  from = aws_ecr_repository.url-monitoring-repository
  to   = aws_ecr_repository.url_monitoring_repository
}

moved {
  from = aws_sns_topic.url-monitor-alerts
  to   = aws_sns_topic.url_monitor_alerts
}
