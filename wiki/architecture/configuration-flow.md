# Configuration and ownership

The main root reads inputs from [variables.tf](../../variables.tf), derives names/topology in [locals.tf](../../locals.tf), then wires [modules](../modules/README.md) from [main.tf](../../main.tf). Profiles provide settings, not state isolation.

For a future plan, provide local context values and **one** selected profile. Terraform input precedence matters: later `-var-file` values replace earlier values for the same variable. An object is not merged recursively. Supply a complete desired `deploy` object in the final file when overriding profile flags.

The seven independent examples are separate roots. Each owns its own resource group, provider configuration, input contract and state. Do not apply them from the main root or reuse the main root's state file.

The [future operation guide](../../docs/operations/deployment-checklist.md) documents input and state review. The current work performs local validation only and never uses live plan/apply/destroy as a check.
