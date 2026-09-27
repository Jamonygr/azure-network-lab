variable "ctx" {
  description = "Lab naming, region and tags; existing project names retain their resource names."
  type        = object({ project = string, location = string, tags = map(string) })
  validation {
    condition     = can(regex("^[a-z0-9-]{1,40}$", var.ctx.project)) && can(regex("^[a-z0-9]+$", var.ctx.location))
    error_message = "Use a lowercase project (1-40 characters) and Azure region name."
  }
}
variable "subscription_id" {
  description = "Explicit subscription targeted by this configuration."
  type        = string
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id))
    error_message = "subscription_id must be a GUID."
  }
}
variable "deploy" {
  description = "Opt-in services. Explicit legacy objects retain Log Analytics unless set false; the default is minimal."
  type = object({
    spoke_peering       = optional(bool, false)
    vwan                = optional(bool, false)
    vhub_firewall       = optional(bool, false)
    vpn                 = optional(bool, false)
    route_server        = optional(bool, false)
    dns_resolver        = optional(bool, false)
    private_dns_zones   = optional(bool, false)
    bastion             = optional(bool, false)
    application_gateway = optional(bool, false)
    load_balancer       = optional(bool, false)
    nat_gateway         = optional(bool, false)
    private_endpoint    = optional(bool, false)
    spoke1_vms          = optional(bool, false)
    spoke2_vms          = optional(bool, false)
    onprem_vms          = optional(bool, false)
    nvas                = optional(bool, false)
    log_analytics       = optional(bool, true)
    monitoring          = optional(bool, false)
  })
  default = { log_analytics = false, spoke_peering = true }
  validation {
    condition     = !(var.deploy.application_gateway && var.deploy.vhub_firewall && !var.deploy.route_server)
    error_message = "Application Gateway cannot use the secured-hub default route in this lab; use application-delivery or the isolated Route Server spoke profile."
  }
  validation {
    condition     = !var.deploy.spoke_peering || !var.deploy.vwan || var.deploy.route_server
    error_message = "Explicit spoke peering with vWAN is allowed only in the isolated Route Server topology; direct peering would bypass hub routing."
  }
  validation {
    condition     = (!var.deploy.vhub_firewall && !var.deploy.vpn) || var.deploy.vwan
    error_message = "Firewall and S2S VPN require deploy.vwan."
  }
  validation {
    condition     = !var.deploy.monitoring || var.deploy.log_analytics
    error_message = "Monitoring requires deploy.log_analytics."
  }
  validation {
    condition     = (!var.deploy.application_gateway && !var.deploy.load_balancer) || var.deploy.spoke1_vms
    error_message = "Application Gateway and Load Balancer require spoke1_vms for working web backends."
  }
  validation {
    condition     = !(var.deploy.onprem_vms || var.deploy.nvas || (var.deploy.spoke1_vms && !(var.deploy.vhub_firewall && !var.deploy.route_server)) || (var.deploy.spoke2_vms && !var.deploy.vhub_firewall)) || var.deploy.nat_gateway
    error_message = "VMs outside secured-hub internet routing require explicit NAT (deploy.nat_gateway)."
  }
}
variable "vhub_address_prefix" {
  description = "Canonical IPv4 hub prefix, /23 or larger, distinct from every VNet prefix."
  type        = string
  default     = "10.10.0.0/23"
  validation {
    condition     = try(cidrhost(var.vhub_address_prefix, 0) == split("/", var.vhub_address_prefix)[0] && tonumber(split("/", var.vhub_address_prefix)[1]) <= 23 && can(cidrnetmask(var.vhub_address_prefix)), false)
    error_message = "vhub_address_prefix must be a canonical IPv4 network of /23 or larger."
  }
}

variable "spoke1_address_space" {
  description = "Canonical nonoverlapping IPv4 ranges; first range /8-/20 supplies stable subnet offsets."
  type        = list(string)
  default     = ["10.1.0.0/16"]
  validation {
    condition     = try(length(var.spoke1_address_space) > 0 && alltrue([for cidr in var.spoke1_address_space : can(cidrnetmask(cidr)) && cidrhost(cidr, 0) == split("/", cidr)[0]]) && tonumber(split("/", var.spoke1_address_space[0])[1]) >= 8 && tonumber(split("/", var.spoke1_address_space[0])[1]) <= 20, false)
    error_message = "Address spaces must be canonical IPv4; first range must be between /8 and /20."
  }
}

variable "spoke2_address_space" {
  description = "Canonical nonoverlapping IPv4 ranges; first range /8-/20 supplies stable subnet offsets."
  type        = list(string)
  default     = ["10.2.0.0/16"]
  validation {
    condition     = try(length(var.spoke2_address_space) > 0 && alltrue([for cidr in var.spoke2_address_space : can(cidrnetmask(cidr)) && cidrhost(cidr, 0) == split("/", cidr)[0]]) && tonumber(split("/", var.spoke2_address_space[0])[1]) >= 8 && tonumber(split("/", var.spoke2_address_space[0])[1]) <= 20, false)
    error_message = "Address spaces must be canonical IPv4; first range must be between /8 and /20."
  }
}

variable "onprem_address_space" {
  description = "Canonical nonoverlapping IPv4 ranges; first range /8-/20 supplies stable subnet offsets."
  type        = list(string)
  default     = ["192.168.0.0/16"]
  validation {
    condition     = try(length(var.onprem_address_space) > 0 && alltrue([for cidr in var.onprem_address_space : can(cidrnetmask(cidr)) && cidrhost(cidr, 0) == split("/", cidr)[0]]) && tonumber(split("/", var.onprem_address_space[0])[1]) >= 8 && tonumber(split("/", var.onprem_address_space[0])[1]) <= 20, false)
    error_message = "Address spaces must be canonical IPv4; first range must be between /8 and /20."
  }
}

variable "admin_username" {
  description = "Local administrator on optional Windows VMs."
  type        = string
  default     = "azureadmin"
  validation {
    condition     = length(var.admin_username) >= 1 && length(var.admin_username) <= 20 && !contains(["admin", "administrator", "user"], lower(var.admin_username))
    error_message = "Use a nonreserved username of 1-20 characters."
  }
}
variable "admin_password" {
  description = "Optional VM password; supply through TF_VAR_admin_password, never a committed profile. Terraform stores it in state."
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = anytrue([var.deploy.spoke1_vms, var.deploy.spoke2_vms, var.deploy.onprem_vms, var.deploy.nvas]) ? try(length(var.admin_password) >= 12 && length(var.admin_password) <= 123 && sum([for pattern in ["[A-Z]", "[a-z]", "[0-9]", "[^A-Za-z0-9]"] : can(regex(pattern, var.admin_password)) ? 1 : 0]) >= 3, false) : true
    error_message = "Enabled VMs require admin_password of 12-123 characters with three of uppercase, lowercase, numbers and symbols."
  }
}
variable "vm_size" {
  description = "Size for optional Windows VMs."
  type        = string
  default     = "Standard_B2s"
}
variable "vpn_shared_key" {
  description = "Optional S2S pre-shared key; supply through TF_VAR_vpn_shared_key. Terraform stores it in state."
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = var.deploy.vpn ? try(length(var.vpn_shared_key) >= 12 && length(var.vpn_shared_key) <= 128, false) : true
    error_message = "S2S VPN requires vpn_shared_key of 12-128 characters."
  }
}
variable "administration_source_cidrs" {
  description = "Additional exact IPv4 source networks allowed RDP; Bastion subnet is included automatically."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for cidr in var.administration_source_cidrs : can(cidrnetmask(cidr)) && !endswith(cidr, "/0")])
    error_message = "Administration sources must be scoped IPv4 CIDRs; /0 is prohibited."
  }
}
variable "firewall_allowed_fqdns" {
  description = "HTTPS outbound destinations; all other public destinations are denied. Windows Update uses a separate Microsoft FQDN tag."
  type        = list(string)
  default     = ["www.microsoft.com", "learn.microsoft.com"]
  validation {
    condition     = length(var.firewall_allowed_fqdns) > 0 && alltrue([for fqdn in var.firewall_allowed_fqdns : fqdn != "*" && can(regex("^[A-Za-z0-9*.-]+[.][A-Za-z]+$", fqdn))])
    error_message = "Supply explicit DNS names; a global wildcard is not allowed."
  }
}
variable "dns_forwarding_rules" {
  description = "Conditional forwarding to reachable external DNS servers. Domains end in a dot; never point a rule back at this resolver's inbound endpoint."
  type = map(object({
    domain_name        = string
    target_dns_servers = list(object({ ip_address = string, port = optional(number, 53) }))
    enabled            = optional(bool, true)
  }))
  default = {}
  validation {
    condition     = alltrue([for rule in values(var.dns_forwarding_rules) : endswith(rule.domain_name, ".") && length(rule.target_dns_servers) > 0 && alltrue([for server in rule.target_dns_servers : can(cidrnetmask("${server.ip_address}/32")) && server.port >= 1 && server.port <= 65535])])
    error_message = "DNS rules need trailing-dot domains and valid IPv4 DNS targets/ports."
  }
}
variable "dns_forwarding_link_vnets" {
  description = "VNets linked to the outbound forwarding ruleset. Empty rules create an inert ruleset, not a pretend on-prem DNS server."
  type        = set(string)
  default     = ["spoke1", "spoke2"]
  validation {
    condition     = alltrue([for key in var.dns_forwarding_link_vnets : contains(["spoke1", "spoke2", "onprem"], key)])
    error_message = "Choose spoke1, spoke2 or onprem."
  }
}
variable "application_gateway" {
  description = "WAF_v2 settings. HTTPS references an existing Key Vault certificate secret and a reader identity; no PFX/password is stored here."
  type = object({
    autoscale_min         = optional(number, 1)
    autoscale_max         = optional(number, 2)
    waf_mode              = optional(string, "Prevention")
    certificate_secret_id = optional(string)
    identity_ids          = optional(set(string), [])
    host_name             = optional(string)
  })
  default = {}
  validation {
    condition     = var.application_gateway.autoscale_min >= 0 && var.application_gateway.autoscale_max >= max(2, var.application_gateway.autoscale_min) && var.application_gateway.autoscale_max <= 10 && contains(["Detection", "Prevention"], var.application_gateway.waf_mode)
    error_message = "Use valid WAF mode and autoscale min/max (max 2-10)."
  }
  validation {
    condition     = var.application_gateway.certificate_secret_id == null ? length(var.application_gateway.identity_ids) == 0 : length(var.application_gateway.identity_ids) == 1 && var.application_gateway.host_name != null
    error_message = "HTTPS requires exactly one existing user-assigned identity and a DNS host name."
  }
}
variable "monitoring" {
  description = "Opt-in monitoring settings. Reuse an existing regional Network Watcher; this lab does not own/delete that shared service."
  type = object({
    network_watcher    = optional(object({ name = string, resource_group_name = string }))
    flow_logs          = optional(bool, true)
    traffic_analytics  = optional(bool, false)
    connection_monitor = optional(bool, false)
    connection_target  = optional(string, "www.microsoft.com")
    retention_days     = optional(number, 7)
  })
  default = {}
  validation {
    condition     = !var.deploy.monitoring || (!(var.monitoring.flow_logs || var.monitoring.connection_monitor) || var.monitoring.network_watcher != null)
    error_message = "Flow logs/Connection Monitor require an existing Network Watcher in ctx.location."
  }
  validation {
    condition     = !var.monitoring.traffic_analytics || var.monitoring.flow_logs
    error_message = "Traffic Analytics requires flow_logs."
  }
  validation {
    condition     = !var.deploy.monitoring || !var.monitoring.connection_monitor || var.deploy.spoke1_vms
    error_message = "Connection Monitor requires spoke1_vms."
  }
  validation {
    condition     = var.monitoring.retention_days >= 1 && var.monitoring.retention_days <= 30
    error_message = "Lab retention must be 1-30 days."
  }
}

# This input exists only to attach a blocking cross-input validation; it is never a bypass.
# tflint-ignore: terraform_unused_declarations
variable "validate_address_plan" {
  description = "Always validates all hub/VNet ranges; this is not a bypass switch."
  type        = bool
  default     = true
  validation {
    condition     = var.validate_address_plan && local.nonoverlapping_ranges
    error_message = "All VNet and hub CIDRs must be mutually nonoverlapping (including secondary ranges)."
  }
}
