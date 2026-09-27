variable "name" {
  description = "Lab prefix for monitoring resources."
  type        = string
}
variable "resource_group_name" {
  description = "Lab resource group; shared Network Watcher is read only."
  type        = string
}
variable "ctx" {
  description = "Location and tags."
  type        = object({ project = string, location = string, tags = map(string) })
}
variable "network_watcher" {
  description = "Existing Network Watcher in the lab region, needed for flow logs or Connection Monitor."
  type        = object({ name = string, resource_group_name = string })
  default     = null
}
variable "workspace_resource_id" {
  description = "Destination Log Analytics ARM resource ID."
  type        = string
}
variable "workspace_id" {
  description = "Log Analytics workspace GUID for Traffic Analytics."
  type        = string
}
variable "vnet_ids" {
  description = "VNets receiving VNet flow logs, never legacy NSG flow logs."
  type        = map(string)
}
variable "diagnostic_target_ids" {
  description = "Enabled Firewall, Application Gateway and VPN resources."
  type        = map(string)
  default     = {}
}
variable "flow_logs" {
  description = "Enable VNet flow logs and a dedicated storage account."
  type        = bool
  default     = true
}
variable "traffic_analytics" {
  description = "Opt-in paid flow analysis."
  type        = bool
  default     = false
}
variable "connection_monitor" {
  description = "Enable a TCP/443 probe and Windows Network Watcher agent."
  type        = bool
  default     = false
}
variable "source_vm_id" {
  description = "Existing Windows VM to run the connectivity probe."
  type        = string
  default     = null
}
variable "connection_target" {
  description = "Approved destination for the TCP/443 probe."
  type        = string
  default     = "www.microsoft.com"
}
variable "retention_days" {
  description = "Flow-log retention, 1-30 days for this lab."
  type        = number
  default     = 7
}
