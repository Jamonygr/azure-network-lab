# Cost planning worksheet

No price estimate in this repository is a quote. Select region, currency, offer, duration, capacity, storage, data processing and diagnostic volume in the [Azure pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator/) before any future deployment.

| Footprint | Costs to inventory |
|---|---|
| Minimal | Reserved network configuration; later added services/transfer change the footprint |
| Secured vWAN | Hub, Firewall base/capacity, public addresses and processing |
| Hybrid VPN | Hub VPN scale, VNet gateway, hub and transfer |
| Route Server | Routing service, two NVAs, disks and NAT services |
| Private DNS | Resolver endpoints, private endpoint hours/data, DNS and storage |
| Delivery | App Gateway capacity/data, two Windows VMs/disks, NAT, public addresses |
| Independent examples | App Service plans, Front Door, Traffic Manager queries, DDoS plan, AVNM, gateways or example VMs as applicable |
| Observation | Flow storage, retention, Log Analytics ingestion, Traffic Analytics and probes |

A stopped VM can leave disks, IPs, gateways, NAT, protection plans and monitoring billing. A budget notification is not an automatic shutdown guarantee.

Before a future run, record: selected root/profile; resource inventory; planned start/end time; responsible owner; expected data volume; maximum capacity; residual/shared resources; cleanup procedure. Cost-bearing example flags default off where implemented, but enabling them is still a real spending decision.

Do not enable every service simply to claim broader exam coverage. The [design worksheets](../scenarios/design-exercises.md) cover provider/licensing topics without claiming a live deployment.
