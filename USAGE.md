# Usage Examples

This document provides comprehensive examples for using the Azure Monitor Action Group Terraform module.

## Table of Contents

- [Module Inputs Reference](#module-inputs-reference)
- [Basic Email Notification](#basic-email-notification)
- [Multiple Receiver Types](#multiple-receiver-types)
- [Webhook Integration (Teams/Slack)](#webhook-integration-teamsslack)
- [Azure Function Integration](#azure-function-integration)
- [Logic App Integration](#logic-app-integration)
- [Automation Runbook Integration](#automation-runbook-integration)
- [Event Hub Integration](#event-hub-integration)
- [ARM Role Notification](#arm-role-notification)
- [Complete Production Example](#complete-production-example)
- [Multi-Environment Setup](#multi-environment-setup)

---

## Module Inputs Reference

Quick reference for all available inputs when using this module.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the Action Group | `string` | n/a | yes |
| resource_group_name | The name of the resource group in which to create the Action Group | `string` | n/a | yes |
| short_name | The short name of the action group. Maximum 12 characters. Used in SMS and push notifications. | `string` | n/a | yes |
| enabled | Whether the action group is enabled. Set to false to temporarily disable all notifications. | `bool` | `true` | no |
| email_receivers | List of email receivers. Each receiver will get email notifications when alerts are triggered. | <pre>list(object({<br>  name                    = string<br>  email_address           = string<br>  use_common_alert_schema = optional(bool, true)<br>}))</pre> | `[]` | no |
| sms_receivers | List of SMS receivers. Each receiver will get text message notifications. | <pre>list(object({<br>  name         = string<br>  country_code = string<br>  phone_number = string<br>}))</pre> | `[]` | no |
| voice_receivers | List of voice call receivers. Each receiver will get automated voice call notifications. | <pre>list(object({<br>  name         = string<br>  country_code = string<br>  phone_number = string<br>}))</pre> | `[]` | no |
| azure_app_push_receivers | List of Azure mobile app push notification receivers. Requires Azure mobile app. | <pre>list(object({<br>  name          = string<br>  email_address = string<br>}))</pre> | `[]` | no |
| arm_role_receivers | List of Azure RBAC role receivers. Notifies all users assigned to the specified role. | <pre>list(object({<br>  name                    = string<br>  role_id                 = string<br>  use_common_alert_schema = optional(bool, true)<br>}))</pre> | `[]` | no |
| webhook_receivers | List of webhook receivers. Sends HTTP POST requests to specified endpoints (Teams, Slack, etc.). | <pre>list(object({<br>  name                    = string<br>  service_uri             = string<br>  use_common_alert_schema = optional(bool, true)<br>}))</pre> | `[]` | no |
| azure_function_receivers | List of Azure Function receivers. Triggers Azure Functions for custom alert processing. | <pre>list(object({<br>  name                     = string<br>  function_app_resource_id = string<br>  function_name            = string<br>  http_trigger_url         = string<br>  use_common_alert_schema  = optional(bool, true)<br>}))</pre> | `[]` | no |
| logic_app_receivers | List of Logic App receivers. Triggers Azure Logic Apps for workflow automation. | <pre>list(object({<br>  name                    = string<br>  resource_id             = string<br>  callback_url            = string<br>  use_common_alert_schema = optional(bool, true)<br>}))</pre> | `[]` | no |
| automation_runbook_receivers | List of Automation Runbook receivers. Executes Azure Automation runbooks for remediation. | <pre>list(object({<br>  name                    = string<br>  automation_account_id   = string<br>  runbook_name            = string<br>  webhook_resource_id     = string<br>  is_global_runbook       = bool<br>  service_uri             = string<br>  use_common_alert_schema = optional(bool, true)<br>}))</pre> | `[]` | no |
| event_hub_receivers | List of Event Hub receivers. Streams alert data to Event Hubs for analysis and archival. | <pre>list(object({<br>  name                    = string<br>  event_hub_namespace     = string<br>  event_hub_name          = string<br>  subscription_id         = optional(string)<br>  tenant_id               = optional(string)<br>  use_common_alert_schema = optional(bool, true)<br>}))</pre> | `[]` | no |
| tags | A mapping of tags to assign to the Action Group resource | `map(string)` | `{}` | no |

---

## Basic Email Notification

Simple action group with email notifications only.

```hcl
module "email_action_group" {
  source = "github.com/deviant101/terraform-azurerm-action-group"

  name                = "email-alerts"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "emailalert"

  email_receivers = [
    {
      name          = "admin"
      email_address = "admin@company.com"
    },
    {
      name          = "ops-team"
      email_address = "ops@company.com"
    }
  ]

  tags = {
    Team = "Operations"
  }
}
```

---

## Multiple Receiver Types

Combine email, SMS, and voice notifications for critical alerts.

```hcl
module "multi_channel_alerts" {
  source = "github.com/deviant101/terraform-azurerm-action-group"

  name                = "multi-channel-alerts"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "multichan"

  email_receivers = [
    {
      name          = "team-lead"
      email_address = "lead@company.com"
    }
  ]

  sms_receivers = [
    {
      name         = "on-call"
      country_code = "1"
      phone_number = "5551234567"
    }
  ]

  voice_receivers = [
    {
      name         = "critical-alerts"
      country_code = "1"
      phone_number = "5559876543"
    }
  ]

  tags = {
    Severity = "Critical"
  }
}
```

---

## Webhook Integration (Teams/Slack)

Send alerts to Microsoft Teams or Slack channels.

### Microsoft Teams

```hcl
module "teams_alerts" {
  source = "github.com/deviant101/terraform-azurerm-action-group"

  name                = "teams-notifications"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "teamsnoti"

  webhook_receivers = [
    {
      name                    = "teams-engineering"
      service_uri             = "https://outlook.office.com/webhook/xxxxx/IncomingWebhook/xxxxx"
      use_common_alert_schema = true
    },
    {
      name                    = "teams-operations"
      service_uri             = "https://outlook.office.com/webhook/xxxxx/IncomingWebhook/yyyyy"
      use_common_alert_schema = true
    }
  ]

  tags = {
    Team = "Platform"
  }
}
```

### Slack Integration

```hcl
module "slack_alerts" {
  source = "github.com/deviant101/terraform-azurerm-action-group"

  name                = "slack-notifications"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "slacknoti"

  webhook_receivers = [
    {
      name                    = "slack-alerts"
      service_uri             = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXX"
      use_common_alert_schema = false  # Slack may need custom formatting
    }
  ]
}
```

### Combined Teams and Slack

```hcl
module "multi_webhook_alerts" {
  source = "github.com/deviant101/terraform-azurerm-action-group"

  name                = "team-chat-alerts"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "chatalerts"

  webhook_receivers = [
    {
      name                    = "teams-channel"
      service_uri             = var.teams_webhook_url
      use_common_alert_schema = true
    },
    {
      name                    = "slack-channel"
      service_uri             = var.slack_webhook_url
      use_common_alert_schema = false
    }
  ]
}
```

---

## Azure Function Integration

Trigger Azure Functions for custom alert processing, enrichment, or routing.

```hcl
resource "azurerm_function_app" "alert_processor" {
  name                       = "alert-processor-func"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
}

module "function_action_group" {
  source = "github.com/deviant101/terraform-azurerm-action-group"

  name                = "function-alerts"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "funcalert"

  azure_function_receivers = [
    {
      name                     = "alert-processor"
      function_app_resource_id = azurerm_function_app.alert_processor.id
      function_name            = "ProcessAlert"
      http_trigger_url         = "https://${azurerm_function_app.alert_processor.default_hostname}/api/ProcessAlert"
      use_common_alert_schema  = true
    },
    {
      name                     = "alert-enrichment"
      function_app_resource_id = azurerm_function_app.alert_processor.id
      function_name            = "EnrichAlert"
      http_trigger_url         = "https://${azurerm_function_app.alert_processor.default_hostname}/api/EnrichAlert"
      use_common_alert_schema  = true
    }
  ]

  tags = {
    Purpose = "Alert Processing"
  }
}
```

---

## Logic App Integration

Use Logic Apps for workflow automation, ticket creation, or complex routing.

### ServiceNow Ticket Creation

```hcl
resource "azurerm_logic_app_workflow" "servicenow_ticket" {
  name                = "create-servicenow-ticket"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_logic_app_trigger_http_request" "alert_trigger" {
  name         = "alert-received"
  logic_app_id = azurerm_logic_app_workflow.servicenow_ticket.id

  schema = <<SCHEMA
{
    "type": "object",
    "properties": {
        "schemaId": {"type": "string"},
        "data": {"type": "object"}
    }
}
SCHEMA
}

module "logic_app_action_group" {
  source = "github.com/deviant101/terraform-azurerm-action-group"

  name                = "logic-app-alerts"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "logicalert"

  logic_app_receivers = [
    {
      name                    = "servicenow-ticket"
      resource_id             = azurerm_logic_app_workflow.servicenow_ticket.id
      callback_url            = azurerm_logic_app_trigger_http_request.alert_trigger.callback_url
      use_common_alert_schema = true
    }
  ]

  tags = {
    Purpose = "ITSM Integration"
  }
}
```

---

## Automation Runbook Integration

Execute Azure Automation runbooks for auto-remediation scenarios.

```hcl
resource "azurerm_automation_account" "example" {
  name                = "remediation-automation"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "Basic"
}

resource "azurerm_automation_runbook" "remediate" {
  name                    = "RemediateAlert"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  automation_account_name = azurerm_automation_account.example.name
  log_verbose             = true
  log_progress            = true
  runbook_type            = "PowerShell"

  content = file("${path.module}/runbooks/remediate.ps1")
}

resource "azurerm_automation_webhook" "remediate_webhook" {
  name                    = "remediate-webhook"
  resource_group_name     = azurerm_resource_group.example.name
  automation_account_name = azurerm_automation_account.example.name
  expiry_time             = "2026-12-31T00:00:00Z"
  enabled                 = true
  runbook_name            = azurerm_automation_runbook.remediate.name
}

module "automation_action_group" {
  source = "github.com/deviant101/terraform-azurerm-action-group"

  name                = "automation-alerts"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "autoalert"

  automation_runbook_receivers = [
    {
      name                    = "auto-remediation"
      automation_account_id   = azurerm_automation_account.example.id
      runbook_name            = azurerm_automation_runbook.remediate.name
      webhook_resource_id     = azurerm_automation_webhook.remediate_webhook.id
      is_global_runbook       = false
      service_uri             = azurerm_automation_webhook.remediate_webhook.uri
      use_common_alert_schema = true
    }
  ]

  tags = {
    Purpose = "Auto-Remediation"
  }
}
```

---

## Event Hub Integration

Stream alerts to Event Hubs for analytics, archival, or SIEM integration.

```hcl
resource "azurerm_eventhub_namespace" "monitoring" {
  name                = "monitoring-eventhub"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "alerts" {
  name                = "alerts"
  namespace_name      = azurerm_eventhub_namespace.monitoring.name
  resource_group_name = azurerm_resource_group.example.name
  partition_count     = 2
  message_retention   = 7
}

module "eventhub_action_group" {
  source = "github.com/deviant101/terraform-azurerm-action-group"

  name                = "eventhub-alerts"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "ehubAlert"

  event_hub_receivers = [
    {
      name                    = "monitoring-stream"
      event_hub_namespace     = azurerm_eventhub_namespace.monitoring.name
      event_hub_name          = azurerm_eventhub.alerts.name
      subscription_id         = data.azurerm_client_config.current.subscription_id
      tenant_id               = data.azurerm_client_config.current.tenant_id
      use_common_alert_schema = true
    }
  ]

  tags = {
    Purpose = "Alert Analytics"
  }
}
```

---

## ARM Role Notification

Notify all users with specific Azure RBAC roles (useful for subscription-level alerts).

```hcl
module "role_based_alerts" {
  source = "github.com/deviant101/terraform-azurerm-action-group"

  name                = "role-based-alerts"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "rolealerts"

  arm_role_receivers = [
    {
      name                    = "subscription-owners"
      role_id                 = "8e3af657-a8ff-443c-a75c-2fe8c4bcb635" # Owner
      use_common_alert_schema = true
    },
    {
      name                    = "subscription-contributors"
      role_id                 = "b24988ac-6180-42a0-ab88-20f7382dd24c" # Contributor
      use_common_alert_schema = true
    },
    {
      name                    = "monitoring-readers"
      role_id                 = "43d0d8ad-25c7-4714-9337-8ba259a9fe05" # Monitoring Reader
      use_common_alert_schema = true
    }
  ]

  tags = {
    Scope = "Subscription"
  }
}
```

### Common Azure RBAC Role IDs

- **Owner**: `8e3af657-a8ff-443c-a75c-2fe8c4bcb635`
- **Contributor**: `b24988ac-6180-42a0-ab88-20f7382dd24c`
- **Reader**: `acdd72a7-3385-48ef-bd42-f606fba81ae7`
- **Monitoring Contributor**: `749f88d5-cbae-40b8-bcfc-e573ddc772fa`
- **Monitoring Reader**: `43d0d8ad-25c7-4714-9337-8ba259a9fe05`

---

## Complete Production Example

Comprehensive action group with multiple notification and action receivers.

```hcl
data "azurerm_client_config" "current" {}

module "production_action_group" {
  source = "github.com/deviant101/terraform-azurerm-action-group"

  name                = "production-alerts"
  resource_group_name = azurerm_resource_group.production.name
  short_name          = "prodalerts"
  enabled             = true

  # === NOTIFICATION RECEIVERS ===
  
  # Email notifications for the team
  email_receivers = [
    {
      name                    = "devops-team"
      email_address           = "devops@company.com"
      use_common_alert_schema = true
    },
    {
      name                    = "platform-team"
      email_address           = "platform@company.com"
      use_common_alert_schema = true
    }
  ]

  # SMS for on-call engineers
  sms_receivers = [
    {
      name         = "on-call-primary"
      country_code = "1"
      phone_number = "5551234567"
    },
    {
      name         = "on-call-secondary"
      country_code = "1"
      phone_number = "5559876543"
    }
  ]

  # Voice calls for critical issues
  voice_receivers = [
    {
      name         = "escalation"
      country_code = "1"
      phone_number = "5555551234"
    }
  ]

  # Mobile app push notifications
  azure_app_push_receivers = [
    {
      name          = "mobile-alerts"
      email_address = "oncall@company.com"
    }
  ]

  # Notify subscription owners for billing/security alerts
  arm_role_receivers = [
    {
      name                    = "subscription-owners"
      role_id                 = "8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
      use_common_alert_schema = true
    }
  ]

  # === ACTION RECEIVERS ===

  # Teams webhook for team visibility
  webhook_receivers = [
    {
      name                    = "teams-operations"
      service_uri             = var.teams_webhook_url
      use_common_alert_schema = true
    }
  ]

  # Azure Function for alert enrichment
  azure_function_receivers = [
    {
      name                     = "alert-enrichment"
      function_app_resource_id = azurerm_function_app.alerts.id
      function_name            = "EnrichAlert"
      http_trigger_url         = "https://alerts-func.azurewebsites.net/api/EnrichAlert"
      use_common_alert_schema  = true
    }
  ]

  # Logic App for ticket creation
  logic_app_receivers = [
    {
      name                    = "create-incident"
      resource_id             = azurerm_logic_app_workflow.incidents.id
      callback_url            = azurerm_logic_app_trigger_http_request.incidents.callback_url
      use_common_alert_schema = true
    }
  ]

  # Automation for auto-remediation
  automation_runbook_receivers = [
    {
      name                    = "auto-remediation"
      automation_account_id   = azurerm_automation_account.remediation.id
      runbook_name            = "RemediateCommonIssues"
      webhook_resource_id     = azurerm_automation_webhook.remediation.id
      is_global_runbook       = false
      service_uri             = azurerm_automation_webhook.remediation.uri
      use_common_alert_schema = true
    }
  ]

  # Event Hub for SIEM integration
  event_hub_receivers = [
    {
      name                    = "siem-integration"
      event_hub_namespace     = azurerm_eventhub_namespace.monitoring.name
      event_hub_name          = azurerm_eventhub.alerts.name
      subscription_id         = data.azurerm_client_config.current.subscription_id
      tenant_id               = data.azurerm_client_config.current.tenant_id
      use_common_alert_schema = true
    }
  ]

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Team        = "Platform"
    CostCenter  = "Engineering"
    Criticality = "High"
  }
}

# Use the action group in alert rules
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "high-cpu-alert"
  resource_group_name = azurerm_resource_group.production.name
  scopes              = [azurerm_virtual_machine.example.id]
  description         = "Alert when CPU exceeds 80%"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = module.production_action_group.id
  }
}
```

---

## Multi-Environment Setup

Manage action groups across different environments with consistent patterns.

```hcl
locals {
  environments = {
    dev = {
      short_name = "devalerts"
      email      = "dev-team@company.com"
      enabled    = true
    }
    staging = {
      short_name = "stgalerts"
      email      = "staging-team@company.com"
      enabled    = true
    }
    production = {
      short_name = "prodalerts"
      email      = "ops-team@company.com"
      enabled    = true
    }
  }
}

module "action_groups" {
  source   = "github.com/deviant101/terraform-azurerm-action-group"
  for_each = local.environments

  name                = "${each.key}-alerts"
  resource_group_name = azurerm_resource_group.monitoring[each.key].name
  short_name          = each.value.short_name
  enabled             = each.value.enabled

  email_receivers = [
    {
      name          = "${each.key}-team"
      email_address = each.value.email
    }
  ]

  webhook_receivers = each.key == "production" ? [
    {
      name        = "teams-production"
      service_uri = var.teams_webhook_url
    }
  ] : []

  tags = {
    Environment = title(each.key)
    ManagedBy   = "Terraform"
  }
}

output "action_group_ids" {
  value = {
    for env, ag in module.action_groups : env => ag.id
  }
}
```

---

## Best Practices

### 1. Use Descriptive Names

```hcl
# Good
name       = "production-critical-alerts"
short_name = "prodcrit"

# Avoid
name       = "ag1"
short_name = "ag1"
```

### 2. Leverage Common Alert Schema

```hcl
# Enable for easier parsing
use_common_alert_schema = true
```

### 3. Separate by Severity

```hcl
# Critical alerts - immediate notification
module "critical_alerts" {
  source = "github.com/deviant101/terraform-azurerm-action-group"
  # ... SMS, Voice, Email
}

# Warning alerts - email only
module "warning_alerts" {
  source = "github.com/deviant101/terraform-azurerm-action-group"
  # ... Email, Teams webhook
}
```

### 4. Use Variables for Secrets

```hcl
variable "teams_webhook_url" {
  description = "Microsoft Teams webhook URL"
  type        = string
  sensitive   = true
}

webhook_receivers = [
  {
    name        = "teams"
    service_uri = var.teams_webhook_url
  }
]
```

### 5. Tag Consistently

```hcl
tags = {
  Environment = var.environment
  ManagedBy   = "Terraform"
  Team        = var.team_name
  CostCenter  = var.cost_center
  Purpose     = "Monitoring"
}
```

---

## Testing Action Groups

After creating action groups, test them using Azure CLI:

```bash
# Test an action group
az monitor action-group test-notifications create \
  --action-group-name "production-alerts" \
  --resource-group "my-resource-group" \
  --notification-type Email SMS Webhook
```

Or use Terraform to create a test alert:

```hcl
resource "azurerm_monitor_metric_alert" "test_alert" {
  name                = "test-action-group"
  resource_group_name = azurerm_resource_group.example.name
  scopes              = [azurerm_storage_account.example.id]
  description         = "Test alert for action group"
  severity            = 3
  enabled             = false  # Keep disabled

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "Transactions"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 1000000
  }

  action {
    action_group_id = module.action_group.id
  }
}
```

---

## Troubleshooting

### Common Issues

1. **Webhook not receiving alerts**: Ensure `use_common_alert_schema` matches your endpoint's expected format
2. **SMS not delivering**: Check country code format and phone number validation
3. **Function timing out**: Increase function timeout and use async processing
4. **Runbook not executing**: Verify webhook hasn't expired and automation account has proper permissions

### Rate Limits

Azure enforces the following rate limits per action group:

- **SMS**: 1 per 5 minutes per phone number
- **Voice**: 1 per 5 minutes per phone number
- **Email**: Maximum 100 per hour
- **Azure app push**: Maximum 100 per hour

---

For more information, refer to the main [README.md](README.md) or [Azure Monitor Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups).
