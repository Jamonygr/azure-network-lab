# Naming and tags

The root derives `local.prefix` from lowercase `ctx.project`. Names such as `rg-<prefix>`, spoke VNets and service-specific prefixes identify ownership. Keep a stable project name when reviewing an existing state's migration; changing it can replace resources.

Tags require Environment, Project, ManagedBy and Purpose. The root merges defaults and context tags. Tags help discovery and cost allocation, but they do not enforce access control or prove a resource belongs to the current state.

Independent examples use their own `lab_id` naming and resource groups. The endpoint-policy example intentionally owns an additional allowed-storage resource group. Include all owned groups in cleanup.

Do not place personal credentials, private endpoints' access details, customer names or secrets in tags or public examples. Use neutral teaching names and publish only redacted evidence.
