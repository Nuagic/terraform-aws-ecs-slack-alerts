resource "aws_cloudwatch_event_rule" "ecs" {
  event_bus_name = "default"
  event_pattern = jsonencode(
    {
      detail-type = [
        "ECS Deployment State Change",
      ]
      source = [
        "aws.ecs",
      ]
    }
  )
  is_enabled = true
  name       = "${var.name}-ecs-slack-${var.env}"
}

resource "aws_cloudwatch_event_target" "sns" {
  event_bus_name = "default"
  rule           = aws_cloudwatch_event_rule.ecs.name
  arn            = aws_sns_topic.sns.arn
}

data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "sns" {
  name = "${var.name}-ecs-slack-${var.env}"
}

resource "aws_sns_topic_policy" "sns" {
  arn = aws_sns_topic.sns.arn
  policy = jsonencode(
    {
      Id = "__default_policy_ID"
      Statement = [
        {
          Sid = "__default_statement_ID"
          Action = [
            "SNS:GetTopicAttributes",
            "SNS:SetTopicAttributes",
            "SNS:AddPermission",
            "SNS:RemovePermission",
            "SNS:DeleteTopic",
            "SNS:Subscribe",
            "SNS:ListSubscriptionsByTopic",
            "SNS:Publish",
          ]
          Condition = {
            StringEquals = {
              "AWS:SourceOwner" = "${data.aws_caller_identity.current.account_id}"
            }
          }
          Effect = "Allow"
          Principal = {
            AWS = "*"
          }
          Resource = aws_sns_topic.sns.arn
        },
        {
          Action = "sns:Publish"
          Effect = "Allow"
          Principal = {
            Service = "events.amazonaws.com"
          }
          Resource = aws_sns_topic.sns.arn
        },
      ]
      Version = "2008-10-17"
    }
  )
}

resource "aws_sns_topic_subscription" "lamda" {
  endpoint             = module.lambda.lambda_function_arn
  protocol             = "lambda"
  raw_message_delivery = false
  topic_arn            = aws_sns_topic.sns.arn
}

module "lambda" {
  source                            = "terraform-aws-modules/lambda/aws"
  version                           = "4.6.1"
  function_name                     = "${var.name}-ecs-slack-${var.env}"
  description                       = "Slack notifier"
  runtime                           = "python3.9"
  handler                           = "lambda_function.lambda_handler"
  source_path                       = "${path.module}/lambda"
  create_package                    = true
  publish                           = true
  cloudwatch_logs_retention_in_days = var.log_retention_in_days
  timeout                           = 5
  allowed_triggers = {
    EventBridge = {
      principal  = "sns.amazonaws.com"
      source_arn = aws_sns_topic.sns.arn
    }
  }
  environment_variables = {
    SLACK_WEBHOOK = var.webHook
  }
}

