# Azure Monitor Action Group Terraform Module

[![Terraform](https://img.shields.io/badge/Terraform-%E2%89%A5%201.0-623CE4?logo=terraform)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Azure-Monitor-0078D4?logo=microsoftazure)](https://azure.microsoft.com/en-us/services/monitor/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A Terraform module for creating and managing Azure Monitor Action Groups with comprehensive support for all receiver types including email, SMS, webhooks, Azure Functions, Logic Apps, and more.

## Features

- ✅ **Complete Receiver Support**: All 10 Azure Action Group receiver types
- 🔔 **Notification Receivers**: Email, SMS, Voice, Azure App Push, ARM Role
- 🔄 **Action Receivers**: Webhook, Azure Function, Logic App, Automation Runbook, Event Hub
- 🎯 **Type Safe**: Strong typing with input validation
- 🚀 **Production Ready**: Follows Terraform best practices
- 📦 **Flexible**: Dynamic blocks for optional configurations
- 🏷️ **Tagging Support**: Full resource tagging capability

## Table of Contents

- [Usage](#usage)
- [Requirements](#requirements)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Receiver Types](#receiver-types)
- [Common Alert Schema](#common-alert-schema)
- [Common Use Cases](#common-use-cases)
- [Notes](#notes)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Usage

Basic example:

```hcl
module "action_group" {
  source = "github.com/deviant101/terraform-azurerm-action-group"

  name                = "my-action-group"
  resource_group_name = "my-resource-group"
  short_name          = "myag"
  enabled             = true

  email_receivers = [
    {
      name                    = "admin-email"
      email_address           = "admin@example.com"
      use_common_alert_schema = true
    }
  ]

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

📚 **For detailed examples and use cases, see [USAGE.md](USAGE.md)**

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Inputs

This module supports 13 input variables for configuring action groups with various receiver types.

**Required Inputs:**
- `name` - The name of the Action Group
- `resource_group_name` - The resource group name
- `short_name` - Short name (max 12 characters)

**Optional Inputs:**
- `enabled` - Enable/disable the action group (default: `true`)
- `email_receivers` - Email notification receivers
- `sms_receivers` - SMS notification receivers
- `voice_receivers` - Voice call receivers
- `azure_app_push_receivers` - Azure mobile app push receivers
- `arm_role_receivers` - Azure RBAC role-based receivers
- `webhook_receivers` - Webhook receivers (Teams, Slack, etc.)
- `azure_function_receivers` - Azure Function receivers
- `logic_app_receivers` - Logic App workflow receivers
- `automation_runbook_receivers` - Automation runbook receivers
- `event_hub_receivers` - Event Hub streaming receivers
- `tags` - Resource tags

📋 **For complete input specifications and types, see [USAGE.md](USAGE.md#module-inputs-reference)**

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Action Group |
| name | The name of the Action Group |
| resource_group_name | The resource group name |

## Receiver Types

### Notification Receivers

These receivers send notifications directly to people:

- **Email Receiver**: Sends email notifications
- **SMS Receiver**: Sends text messages (carrier charges may apply)
- **Voice Receiver**: Makes automated voice calls
- **Azure App Push Receiver**: Sends push notifications to Azure mobile app
- **ARM Role Receiver**: Notifies all users with a specific Azure RBAC role

### Action Receivers

These receivers trigger automated actions:

- **Webhook Receiver**: HTTP POST to custom endpoints (Teams, Slack, PagerDuty, etc.)
- **Azure Function Receiver**: Executes serverless functions for custom logic
- **Logic App Receiver**: Triggers Logic App workflows
- **Automation Runbook Receiver**: Runs automation scripts for remediation
- **Event Hub Receiver**: Streams alerts to Event Hubs for analytics

## Common Alert Schema

The **Common Alert Schema** standardizes alert payloads across Azure Monitor. When enabled (`use_common_alert_schema = true`), all alerts use a consistent JSON format, making it easier to:

- Parse alerts in webhooks and functions
- Build reusable alert processing logic
- Integrate with third-party tools

**Recommendation**: Keep this enabled (default) unless you have specific legacy integrations.

Learn more: [Common Alert Schema Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-common-schema)

## Common Use Cases

1. **Critical Production Alerts**: Email + SMS + Voice for immediate attention
2. **Team Notifications**: Webhooks to Teams/Slack for team awareness
3. **Automated Remediation**: Automation Runbooks to auto-fix known issues
4. **Incident Management**: Logic Apps to create tickets in ServiceNow/Jira
5. **Alert Analytics**: Event Hubs to stream alerts to Log Analytics or Sentinel
6. **Custom Processing**: Azure Functions for alert enrichment and routing

## Notes

- **Short Name Limit**: The `short_name` must be 12 characters or less (validated by the module)
- **Phone Numbers**: For SMS and voice receivers, provide the country code and phone number separately
- **Webhook Security**: Consider using Azure Functions or Logic Apps with managed identities for secure webhook endpoints
- **Rate Limits**: Azure enforces rate limits on notifications (e.g., max 1 SMS per 5 minutes per number)
- **Testing**: Use the "Test action group" feature in Azure Portal to verify configurations

### Rate Limits

Azure enforces the following rate limits per action group:

- **SMS**: 1 per 5 minutes per phone number
- **Voice**: 1 per 5 minutes per phone number  
- **Email**: Maximum 100 per hour
- **Azure app push**: Maximum 100 per hour

## Examples

See [USAGE.md](USAGE.md) for comprehensive examples including:

- Basic email notifications
- Multi-channel alerts (Email, SMS, Voice)
- Teams and Slack webhook integration
- Azure Function integration
- Logic App workflows
- Automation Runbook for auto-remediation
- Event Hub streaming
- ARM role-based notifications
- Complete production setup
- Multi-environment deployments

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This module is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created and maintained by [Farrukh Riaz](https://github.com/deviant101)

## Support

For issues and questions:

- 🐛 [Open an issue](https://github.com/deviant101/terraform-azurerm-action-group/issues)
- 📧 Contact: thefarrukhriaz@gmail.com
- 📚 [Azure Monitor Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/)

## Related Resources

- [Azure Monitor Overview](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)
- [Action Groups Documentation](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups)
- [Common Alert Schema](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-common-schema)
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

---

**⭐ If you find this module useful, please consider giving it a star on GitHub!**
