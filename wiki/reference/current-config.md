# Public baseline, not local environment inventory

This page describes the committed starter. It does **not** mirror private tfvars, Terraform state or an Azure subscription.

The template uses project `az700lab`, region `westeurope`, placeholder subscription GUID and required tags. Root default/minimal selects bidirectional spoke peering and no optional paid services. The default address allocation is [documented separately](../architecture/network-topology.md).

Toolchain: Terraform 1.16.4, AzureRM 4.57.0. The provider lockfiles and [generated reference](../../reference/root.md) record configuration requirements.

Choose one [profile](feature-matrix.md) consciously. Existing explicit deploy objects retain legacy Log Analytics behavior unless they set that flag false. Existing-state upgrades need their own saved plan review; this update neither inspected private state nor applied a migration.

Live deployment and traffic are NOT RUN. Exact local results belong to [validation status](../../docs/validation-status.md), not this baseline page.
