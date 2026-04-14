resource "aws_cloudwatch_dashboard" "main" {
    dashboard_name = "url-monitoring-dashboard"
    dashboard_body = jsonencode({
        widgets = [
        {
            type = "metric",
            x = 0,
            y = 0,
            width = 12,
            height = 6,
            properties = {
            metrics = [
                [ "AWS/Lambda", "Invocations", "FunctionName", "url-monitoring-lambda", { "color": "#2ca02c", "label": "Invocations" } ],
                [ ".", "Errors", ".", ".", { "color": "#d62728", "label": "Errors" } ]
            ],
            view = "timeSeries",
            stacked = false,
            region = var.aws_region,
            title = "Lambda Function Metrics"
            period  = 300
            },
        }
        ,
        {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [ "AWS/Lambda", "Duration", "FunctionName", "url-monitoring-lambda", { "stat": "Average", "label": "Average" } ],
            [ "AWS/Lambda", "Duration", "FunctionName", "url-monitoring-lambda", { "stat": "Maximum", "label": "Maximum" } ]
          ]
          view    = "timeSeries"
          region  = var.aws_region
          title   = "Response Time (Duration)"
        }
      }
    ]
  })
}
