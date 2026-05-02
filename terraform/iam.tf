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
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "sns:Publish"
        ],
        Resource = aws_sns_topic.url_monitor_alerts.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_rollback_policy" {
  name = "url_monitor_lambda_rollback_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:GetAlias",
          "lambda:UpdateAlias",
          "lambda:ListVersionsByFunction"
        ],
        # Ensure the Lambda function resource exists and is named correctly
        Resource = "${aws_lambda_function.url_monitor.arn}:*"
      }
    ]
  })

}