variable "name" {
  description = "Name"
  type        = string
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "webHook" {
  description = "Slack WebHook. See https://slack.com/help/articles/115005265063-Incoming-webhooks-for-Slack"
  type        = string
}

variable "log_retention_in_days" {
  description = "Log retention in days"
  type        = number
  default     = 7
}
