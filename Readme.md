# terraform-aws-ecs-slack-alerts

## Usage 
```terraform
module "ecs-slack" {
  source  = "Nuagic/ecs-slack-alerts/aws"
  name = "mycluster"
  env     = "dev"
  webHook = "https://hooks.slack.com/services/XXXXXXXXXXXX/XXXXXXXXXX/XXXXXXXXXXXXXXX"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Environment | `string` | n/a | yes |
| name | Name | `string` | n/a | yes |
| webHook | Slack WebHook. See https://slack.com/help/articles/115005265063-Incoming-webhooks-for-Slack | `string` | n/a | yes |

## Outputs

No output.

