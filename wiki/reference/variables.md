# Root input contract

[variables.tf](../../variables.tf) is the source of truth; [generated reference](../../reference/root.md) contains the complete schema. The seven independent examples use different inputs.

| Input | Meaning and guardrail |
|---|---|
| `subscription_id` | Explicit GUID; dummy values in examples are not operational credentials |
| `ctx` | `project`, `location`, `tags`; naming and region context |
| `deploy` | Optional service flags; default `{ log_analytics = false, spoke_peering = true }` is minimal |
| `vhub_address_prefix` | Default 10.10.0.0/23 |
| `spoke1_address_space`, `spoke2_address_space`, `onprem_address_space` | Canonical IPv4 lists, first prefix /8–/20; all ranges nonoverlapping |
| `validate_address_plan` | Must remain true; not a validation bypass |
| `admin_username`, `vm_size` | Optional Windows compute settings |
| `admin_password` | Required only for selected VMs/NVAs; sensitive but stored in state |
| `vpn_shared_key` | Required only for root S2S VPN; sensitive but stored in state |
| `administration_source_cidrs` | Additional scoped RDP sources; default empty; /0 rejected |
| `firewall_allowed_fqdns` | Explicit HTTPS names; default www.microsoft.com and learn.microsoft.com |

The `spoke_peering` field defaults false in an explicitly supplied object, while root default/minimal sets it true. Other service flags default false except `log_analytics` **inside an explicitly supplied deploy object**, which defaults true for legacy compatibility. The root default and every shipped profile specify the intended value. Do not assume `deploy = {}` has exactly the same behavior as omitting `deploy`.

Firewall and VPN require vWAN. Monitoring requires Log Analytics. App Gateway/LB require Spoke1 web VMs. Compute outside secured-hub egress requires explicit NAT. Direct spoke peering with a secured vWAN-only shape is rejected to prevent a hub bypass. App Gateway combined with secured-hub default routing is rejected unless the Route Server shape separates Spoke1. Read validation messages rather than bypassing them.

## Conditional DNS forwarding

```hcl
dns_forwarding_rules = {
  branch = {
    domain_name = "branch.example."
    target_dns_servers = [{ ip_address = "192.168.1.10", port = 53 }]
    enabled = true
  }
}
dns_forwarding_link_vnets = ["spoke1", "spoke2"]
```

The IP above is a teaching example; no DNS server is deployed there. Supply a real reachable target before future use. Rules default to an empty map, and VNet keys are limited to spoke1, spoke2 and onprem. Never forward back into this resolver's own inbound endpoint.

## Application Gateway settings

```hcl
application_gateway = {
  autoscale_min = 1
  autoscale_max = 2
  waf_mode      = "Prevention"
  # Optional HTTPS: all three dependencies must be valid.
  # certificate_secret_id = "https://<vault>.vault.azure.net/secrets/<certificate>"
  # identity_ids          = ["<existing-user-assigned-identity-resource-id>"]
  # host_name             = "<owned-hostname>"
}
```

The root supplies actual backend VM addresses. Certificate access/networking, identity permissions and host ownership are external prerequisites. Do not treat frontend HTTPS as backend TLS.

## Monitoring settings

```hcl
monitoring = {
  network_watcher = {
    name                = "NetworkWatcher_westeurope"
    resource_group_name = "NetworkWatcherRG"
  }
  flow_logs          = true
  traffic_analytics  = false
  connection_monitor = false
  connection_target  = "www.microsoft.com"
  retention_days     = 7
}
```

Also set `deploy.monitoring = true` and `deploy.log_analytics = true` in the selected complete deploy object. The watcher must already exist in the selected region. Connection Monitor needs Spoke1 VMs. Traffic Analytics requires flow logs and adds cost. The watcher is shared and not owned by this root; its lab-owned child resources are owned. [Monitoring](../modules/monitoring.md)
