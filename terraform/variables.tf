variable "lambda_target_url" {
  description = "URL to monitor"
  type    = string
  default = "https://www.google.com"
}
variable "lambda_timeout" {
  type    = number
  default = 10
}

variable "lambda_memory" {
  type    = number
  default = 128
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "sns_alert_email" {
  description = "Address where alerts will be sent"
  type        = string
  default     = "ulanowska.joanna@gmail.com"
}
