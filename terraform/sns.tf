resource "aws_sns_topic" "url_monitor_alerts" {
  name = "url-monitor-alerts"
}
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.url_monitor_alerts.arn
  protocol  = "email"
  endpoint  = var.sns_alert_email

}
resource "aws_sns_topic_subscription" "lambda_alert" {
  topic_arn = aws_sns_topic.url_monitor_alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.url_monitor.arn

}