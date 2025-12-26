# Firewall and routing intent

When enabled, Azure Firewall runs inside the vHub (Secured Hub) and routing intent steers traffic through it. This page describes the default lab policy and what it means for traffic flow.

## Firewall deployment

The firewall is created by `modules/vhub-firewall`:

- SKU: AZFW_Hub (Standard).
- Firewall policy: Standard with threat intelligence mode set to Alert.
- DNS proxy enabled.

## Firewall policy (lab defaults)

Rule collection groups created by the module:

### Network rule collection

- Name: `AllowNetworkRules`
- Allows TCP, UDP, and ICMP outbound from 10.0.0.0/8 and 192.168.0.0/16 to any destination.
- Includes an explicit ICMP allow rule for all sources.

### Application rule collection

- Name: `AllowWebTraffic`
- Allows HTTP and HTTPS from 10.0.0.0/8 and 192.168.0.0/16 to any FQDN.

## Routing intent

The module creates vHub routing intent with two policies:

- `InternetTrafficPolicy` -> Azure Firewall
- `PrivateTrafficPolicy` -> Azure Firewall

This pushes both Internet and private traffic through the firewall when the hub is secured.

## vHub connections and Internet security

vHub connections are created with `internet_security_enabled = true`. This flag is required for secure hub inspection behavior when the firewall is present.

## Validation commands

```bash
az network firewall show -g rg-<prefix> -n fw-vhub-<prefix> -o table
az network firewall policy show -g rg-<prefix> -n fwpol-<prefix> -o table
```

## Related pages

- Traffic flows: `architecture/traffic-flows.md`
- Security model: `architecture/security-model.md`
