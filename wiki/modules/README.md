# Module reference and teaching boundaries

The root wires modules; a module's presence does not mean every profile enables it. Read the selected profile alongside [main.tf](../../main.tf) and [locals.tf](../../locals.tf).

| Group | Guide |
|---|---|
| Network topology, routing and DNS | [Networking](networking.md) |
| Windows guests and RRAS | [Compute](compute.md) |
| Policy, administration and private access | [Security](security.md) |
| Logs and probes | [Monitoring](monitoring.md) |
| Storage and service endpoints | [PaaS](paas.md) |

[Generated module index](../../reference/README.md) contains exact Terraform interfaces. Teaching guides explain relationships, prerequisites, evidence and limitations. Update both when a contract changes.

Independent examples own their own roots and resources rather than being automatically invoked by this root. [Example guide](../scenarios/independent-examples.md)

Local schema and mock validation does not prove VM extensions, BGP sessions, certificate retrieval, backend health or Azure quota. These are NOT RUN until a future operator records live evidence.
