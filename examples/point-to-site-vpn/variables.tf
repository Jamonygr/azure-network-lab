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

variable "vpn_aad_audience" {
  description = "Audience GUID for the Azure VPN application approved in your tenant; select it from current Microsoft instructions."
  type        = string
  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.vpn_aad_audience))
    error_message = "Supply the approved VPN audience GUID explicitly."
  }
}
variable "vpn_aad_tenant_url" {
  description = "Explicit global-Azure Entra tenant URL, without trailing slash."
  type        = string
  validation {
    condition     = var.vpn_aad_tenant_url == "https://login.microsoftonline.com/${var.tenant_id}"
    error_message = "VPN tenant URL must match the configured tenant."
  }
}
variable "vpn_aad_issuer_url" {
  description = "Explicit issuer URL from your tenant configuration, including trailing slash."
  type        = string
  validation {
    condition     = var.vpn_aad_issuer_url == "https://sts.windows.net/${var.tenant_id}/"
    error_message = "Use the matching global-Azure tenant issuer URL."
  }
}

variable "vpn_client_address_pool" {
  description = "Canonical private IPv4 /16 through /29 client pool, nonoverlapping with lab 10.88.0.0/16. Check other local/on-prem networks manually."
  type        = string
  default     = "172.28.10.0/24"
  validation {
    condition = try(
      can(cidrnetmask(var.vpn_client_address_pool)) &&
      tonumber(split("/", var.vpn_client_address_pool)[1]) >= 16 &&
      tonumber(split("/", var.vpn_client_address_pool)[1]) <= 29 &&
      split("/", var.vpn_client_address_pool)[0] == cidrhost(var.vpn_client_address_pool, 0) &&
      (
        startswith(cidrhost(var.vpn_client_address_pool, 0), "10.") ||
        startswith(cidrhost(var.vpn_client_address_pool, 0), "192.168.") ||
        (split(".", cidrhost(var.vpn_client_address_pool, 0))[0] == "172" &&
          tonumber(split(".", cidrhost(var.vpn_client_address_pool, 0))[1]) >= 16 &&
        tonumber(split(".", cidrhost(var.vpn_client_address_pool, 0))[1]) <= 31)
      ) &&
      (
        sum([for index, octet in split(".", cidrhost(var.vpn_client_address_pool, -1)) : tonumber(octet) * pow(256, 3 - index)]) < 173539328 ||
        sum([for index, octet in split(".", cidrhost(var.vpn_client_address_pool, 0)) : tonumber(octet) * pow(256, 3 - index)]) > 173604863
      ),
      false
    )
    error_message = "Use a canonical private IPv4 /16-/29 pool outside 10.88.0.0/16."
  }
}
