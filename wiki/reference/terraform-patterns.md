# Terraform patterns

This repo follows a small set of patterns to keep the root module readable and to avoid optional-resource drift.

## Shared ctx object

All modules accept a `ctx` object (project, location, tags), which reduces input sprawl and enforces consistent tagging.

## Data-driven maps

Most resources are created via `for_each` maps in `locals.tf`:

- VNets and subnets
- NSGs and rules
- VM instances and NVAs
- vHub connections and BGP peers

This makes the topology easy to extend by adding new entries.

## Filtered maps for feature flags

Optional resources use filtered maps to avoid partial state:

```hcl
vhub_connections_enabled = { for k, v in local.vhub_connections : k => v if v.enabled }
```

## Conditional modules with count

Modules that are strictly on/off use `count` to avoid creating resources:

```hcl
module "vhub_firewall" {
  count = var.deploy.vwan && var.deploy.vhub_firewall ? 1 : 0
  # ...
}
```

## Guardrails and validations

- Variable validations enforce naming and location formats.
- Storage account uses a `precondition` to prevent accidental public access.

## Safe lookups

`try()` is used when optional module outputs may not exist:

```hcl
vhub_id = try(module.vhub[0].id, null)
```

## State safety

`moved` blocks in `moved.tf` preserve state addresses after refactors.
