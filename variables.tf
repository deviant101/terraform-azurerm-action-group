variable "name" {
  description = "The name of the Action Group"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Action Group"
  type        = string
}

variable "short_name" {
  description = "The short name of the action group (max 12 characters)"
  type        = string
  validation {
    condition     = length(var.short_name) <= 12
    error_message = "The short_name must be 12 characters or less."
  }
}

variable "enabled" {
  description = "Whether the action group is enabled"
  type        = bool
  default     = true
}

variable "email_receivers" {
  description = "List of email receivers"
  type = list(object({
    name                    = string
    email_address           = string
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "sms_receivers" {
  description = "List of SMS receivers"
  type = list(object({
    name         = string
    country_code = string
    phone_number = string
  }))
  default = []
}

variable "webhook_receivers" {
  description = "List of webhook receivers"
  type = list(object({
    name                    = string
    service_uri             = string
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "azure_app_push_receivers" {
  description = "List of Azure app push receivers"
  type = list(object({
    name          = string
    email_address = string
  }))
  default = []
}

variable "azure_function_receivers" {
  description = "List of Azure Function receivers"
  type = list(object({
    name                     = string
    function_app_resource_id = string
    function_name            = string
    http_trigger_url         = string
    use_common_alert_schema  = optional(bool, true)
  }))
  default = []
}

variable "logic_app_receivers" {
  description = "List of Logic App receivers"
  type = list(object({
    name                    = string
    resource_id             = string
    callback_url            = string
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "automation_runbook_receivers" {
  description = "List of Automation Runbook receivers"
  type = list(object({
    name                    = string
    automation_account_id   = string
    runbook_name            = string
    webhook_resource_id     = string
    is_global_runbook       = bool
    service_uri             = string
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "voice_receivers" {
  description = "List of voice call receivers"
  type = list(object({
    name         = string
    country_code = string
    phone_number = string
  }))
  default = []
}

variable "arm_role_receivers" {
  description = "List of ARM role receivers"
  type = list(object({
    name                    = string
    role_id                 = string
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "event_hub_receivers" {
  description = "List of Event Hub receivers"
  type = list(object({
    name                    = string
    event_hub_namespace     = string
    event_hub_name          = string
    subscription_id         = optional(string)
    tenant_id               = optional(string)
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
