variable "name" {
  description = "Name of the Virtual Machine"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "VM name must be lowercase letters, numbers, and hyphens only."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for the VM"
  type        = string
}

variable "size" {
  description = "Size of the VM"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  sensitive   = true
}

variable "join_lb_backend_pool" {
  description = "Whether to join the VM to a load balancer backend pool"
  type        = bool
  default     = false
}

variable "ctx" {
  description = "Context for location and tags."
  type = object({
    project  = string
    location = string
    tags     = map(string)
  })
}

variable "lb_backend_pool_id" {
  description = "ID of the Load Balancer backend pool to join (optional)"
  type        = string
  default     = null

  validation {
    condition     = var.join_lb_backend_pool ? var.lb_backend_pool_id != null : true
    error_message = "lb_backend_pool_id must be set when join_lb_backend_pool is true."
  }
}
