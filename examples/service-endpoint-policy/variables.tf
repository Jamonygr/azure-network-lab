variable "lab_id" {
  description = "Unique disposable lab identifier."
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9]{2,11}$", var.lab_id))
    error_message = "Use 3-12 lowercase letters/digits, starting with a letter."
  }
}
variable "subscription_id" {
  description = "Explicit target subscription GUID."
  type        = string
  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id))
    error_message = "Supply a subscription GUID."
  }
}
variable "tenant_id" {
  description = "Microsoft Entra tenant GUID."
  type        = string
  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.tenant_id))
    error_message = "Supply a tenant GUID."
  }
}
variable "location" {
  description = "Azure region supporting the selected services."
  type        = string
  default     = "westeurope"
}
variable "enable_paid_features" {
  description = "Acknowledge billable resources after reviewing current prices."
  type        = bool
  default     = false
}

variable "ssh_public_key" {
  description = "Existing RSA SSH public key (2048+ bits). Never supply the private key; no public SSH ingress is opened."
  type        = string
  validation {
    condition     = startswith(trimspace(var.ssh_public_key), "ssh-rsa ") && !strcontains(var.ssh_public_key, "PRIVATE KEY")
    error_message = "Supply only an OpenSSH RSA public key."
  }
}
