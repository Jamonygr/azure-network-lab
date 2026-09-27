# Domain 5 — Network security

Use [secured hub](../scenarios/secured-hub-firewall.md), [AVNM](../../examples/avnm/README.md), [DDoS](../../examples/ddos-protection/README.md), and [delivery](../scenarios/edge-services.md) to reason about controls with different scopes.

## Build a control table

For each allowed connection, write source, destination, protocol/port, owner, business purpose and expiration. Then identify where the control is evaluated: AVNM administration, subnet/NIC NSG, routed Firewall, application WAF, and service access policy. An ASG describes a grouping for rules; it is not a routing mechanism.

AVNM security administration has actions with different downstream effects. An Allow rule can still leave NSG evaluation relevant; Always Allow has different semantics. The independent example's scopes and static membership must be reviewed before any later deployment. [Security admin rules](https://learn.microsoft.com/en-us/azure/virtual-network-manager/concept-security-admins)

Firewall inspection only applies if the path reaches the Firewall. WAF examines supported HTTP traffic; it does not replace transport controls. Use rule identifiers and flow direction when interpreting a denial.

## Interpret evidence

VNet flow logs replace new NSG flow-log deployments. New NSG flow-log creation stopped in June 2025 and retirement is September 2027. Use VNet-level records, with their actual schema, and distinguish an allowed flow from an application transaction. [Microsoft monitoring guidance](https://learn.microsoft.com/en-us/azure/networking/design-guide/monitor)

The monitoring module can describe diagnostics and probes, but portal state, flow logs and actual requests remain unverified. [Monitoring guide](../modules/monitoring.md)

## Completion artifact

Submit an access-control table, one synthetic permitted and denied flow, a WAF detection-versus-prevention decision, and a DDoS cost/monitoring decision. Use the [Defender worksheet](../scenarios/design-exercises.md#defender-investigation) to explain a possible attack path without asserting that a real environment was assessed. No attack generation is part of the DDoS exercise.
