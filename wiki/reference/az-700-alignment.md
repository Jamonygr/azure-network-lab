# AZ-700 objective-to-artifact matrix

Baseline: **27 July 2026**, reviewed **27 September 2026**. The [official study guide](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-700) defines exam wording. This original matrix uses compact topic labels and positional IDs: within each subgroup, `01` is the first official bullet, `02` the second, and so on. Rows preserve that order, including topics that remain design-only.

The official change log marks IP addressing, monitoring and NSG groups as minor changes; it does not give a bullet-level before/after diff. Do not describe every topic below as newly added in July.

**Terraform-backed** = corresponding declared/wired configuration exists, with scope stated below. **Reference configuration** = code pattern, future diagnostic procedure or external-input configuration. **Design exercise** = a reasoned worksheet with no implementation claim. All live deployment, guest, client and packet behavior is **NOT RUN** regardless of label. [Validation status](../../docs/validation-status.md)

Domain weights: core 25–30%; connectivity 20–25%; delivery 15–20%; private access 10–15%; security 15–20%.

## CORE-IP — Address planning

[Domain chapter](../domains/01-core.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| CORE-IP-01 | Segmentation ledger | Terraform-backed | Root parent prefixes and derived subnet ranges; inspect overlap guardrails. |
| CORE-IP-02 | VNet declaration | Terraform-backed | Three root VNets; independent examples own additional separate networks. |
| CORE-IP-03 | Service subnet allocation | Terraform-backed | Reserved gateway, endpoint, resolver, App Gateway and Bastion subnets; service enablement is separate. |
| CORE-IP-04 | Subnet delegation | Terraform-backed | Resolver subnet delegation in root VNet configuration. |
| CORE-IP-05 | Shared versus dedicated decision | Design exercise | Address ledger explains which service subnets cannot host unrelated workloads. |
| CORE-IP-06 | Public prefix resource | Reference configuration | Reference HCL creates a Standard public prefix; not part of root profiles. |
| CORE-IP-07 | Prefix selection rationale | Design exercise | BYOIP/public-prefix worksheet distinguishes a prefix from individual IPs. |
| CORE-IP-08 | Customer-owned prefix | Design exercise | BYOIP worksheet requires real ownership/advertisement prerequisites. |
| CORE-IP-09 | Public address resource | Terraform-backed | NAT, gateway and delivery modules create Standard addresses when selected. |
| CORE-IP-10 | Public address attachment | Terraform-backed | Module associations connect addresses to their intended service. |

## CORE-DNS — Name resolution

[Domain chapter](../domains/01-core.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| CORE-DNS-01 | Intra-VNet resolver choice | Reference configuration | DNS worksheet identifies the client resolver before querying. |
| CORE-DNS-02 | VNet DNS configuration | Reference configuration | Reference settings describe explicit custom DNS versus Azure DNS. |
| CORE-DNS-03 | Public namespace design | Design exercise | Public/private DNS comparison includes delegation and ownership. |
| CORE-DNS-04 | Private namespace design | Terraform-backed | Root private-zone names and VNet links. |
| CORE-DNS-05 | Zone resources and records | Reference configuration | Private zones are rooted; public-zone record HCL is reference only. |
| CORE-DNS-06 | Private-zone VNet link | Terraform-backed | Root private DNS module links selected VNets. |
| CORE-DNS-07 | Private Resolver components | Terraform-backed | Inbound/outbound endpoints, ruleset, explicit rules and links. |

## CORE-ROUTE — Path selection

[Domain chapter](../domains/01-core.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| CORE-ROUTE-01 | Chaining and gateway transit | Reference configuration | Route worksheet compares hops and reverse paths; no appliance chain implied. |
| CORE-ROUTE-02 | VNet peer resources | Terraform-backed | Minimal and Route Server shapes create bidirectional root spoke peers. |
| CORE-ROUTE-03 | AVNM connectivity | Terraform-backed | Independent AVNM root owns group membership and connectivity deployment. |
| CORE-ROUTE-04 | Explicit route object | Reference configuration | Reference UDR HCL; main-root ordinary UDR resources are not claimed. |
| CORE-ROUTE-05 | Route-table attachment | Reference configuration | Reference subnet association with explicit target IDs. |
| CORE-ROUTE-06 | Forced egress choice | Terraform-backed | Secured-hub Internet routing intent; ordinary UDR variant is reference. |
| CORE-ROUTE-07 | Routing diagnosis | Reference configuration | Effective-route and next-hop worksheet; live findings NOT RUN. |
| CORE-ROUTE-08 | Route Server configuration | Terraform-backed | Root service and peer declarations; guest/session acceptance remains unverified. |
| CORE-ROUTE-09 | NAT decision | Design exercise | Compare subnet NAT with routed Firewall and public-LB outbound. |
| CORE-ROUTE-10 | NAT association | Terraform-backed | Root explicit NAT for eligible compute/NVA subnets. |

## CORE-OBS — Network observation

[Domain chapter](../domains/01-core.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| CORE-OBS-01 | Network Watcher logging | Terraform-backed | Opt-in VNet flow logs and Connection Monitor reuse an existing watcher. |
| CORE-OBS-02 | Network health diagnosis | Reference configuration | Diagnostic commands and evidence matrix; no live health result. |
| CORE-OBS-03 | Network Insights interpretation | Reference configuration | Monitoring worksheet correlates resource health and diagnostic signals. |
| CORE-OBS-04 | DDoS configuration/observation | Terraform-backed | Independent protection example and alerts; no attack generation. |
| CORE-OBS-05 | Posture recommendation | Design exercise | Defender synthetic worksheet; no real score queried. |
| CORE-OBS-06 | Attack-path reasoning | Design exercise | Defender worksheet asks for evidence for every relationship. |
| CORE-OBS-07 | Cloud resource exploration | Design exercise | Defender worksheet identifies permissions/features and missing evidence. |

## CONN-S2S — Site connections

[Domain chapter](../domains/02-connectivity.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| CONN-S2S-01 | Resilient tunnel design | Design exercise | External VPN worksheet addresses failure domains beyond the single-region analogue. |
| CONN-S2S-02 | Gateway sizing choice | Design exercise | Compare throughput, features and regional SKU support before future use. |
| CONN-S2S-03 | S2S resources | Terraform-backed | Hybrid profile wires two Azure gateway types and connections. |
| CONN-S2S-04 | Policy/route-based choice | Design exercise | External-device compatibility worksheet. |
| CONN-S2S-05 | Local gateway resource | Terraform-backed | Root local-network-gateway module. |
| CONN-S2S-06 | Cryptographic policy | Reference configuration | Standalone IPsec reference block and device worksheet; root uses its current connection settings. |
| CONN-S2S-07 | VNet gateway resource | Terraform-backed | Root simulated-branch gateway module. |
| CONN-S2S-08 | Gateway diagnosis | Reference configuration | Tunnel/BGP/route evidence sequence. |
| CONN-S2S-09 | Address extension | Design exercise | External VPN worksheet evaluates Azure Extended Network applicability. |

## CONN-P2S — Client connections

[Domain chapter](../domains/02-connectivity.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| CONN-P2S-01 | Client gateway choice | Design exercise | P2S README plus connectivity selection worksheet. |
| CONN-P2S-02 | Tunnel configuration | Terraform-backed | Independent P2S root selects OpenVPN. |
| CONN-P2S-03 | Authentication choice | Design exercise | Compare Entra, RADIUS and certificates against client requirements. |
| CONN-P2S-04 | RADIUS alternative | Design exercise | External authentication server/client dependencies are not configured. |
| CONN-P2S-05 | Entra configuration | Terraform-backed | Explicit audience, tenant and issuer inputs; consent/login external. |
| CONN-P2S-06 | Client profile | Reference configuration | P2S README future client steps; no profile imported. |
| CONN-P2S-07 | Client diagnosis | Reference configuration | Authentication, client route and DNS evidence checklist. |
| CONN-P2S-08 | Always On requirements | Design exercise | External VPN/client worksheet. |
| CONN-P2S-09 | Azure Network Adapter | Design exercise | External VPN/client worksheet; not a root deployment. |

## CONN-ER — Provider connectivity

[Domain chapter](../domains/02-connectivity.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| CONN-ER-01 | Connectivity model | Design exercise | ExpressRoute worksheet marks provider ownership. |
| CONN-ER-02 | Tier and SKU choice | Design exercise | Worksheet compares requirements and ongoing charges. |
| CONN-ER-03 | Regional resilience | Design exercise | Two-site/two-region failure-domain exercise. |
| CONN-ER-04 | Connectivity options | Design exercise | Worksheet compares Global Reach, FastPath and Direct dependencies. |
| CONN-ER-05 | Peering selection | Design exercise | Private/Microsoft peering decision table. |
| CONN-ER-06 | Private peering | Design exercise | Address/ASN/advertisement worksheet; no circuit available. |
| CONN-ER-07 | Microsoft peering | Design exercise | Service reachability and advertisement worksheet. |
| CONN-ER-08 | Gateway design | Design exercise | Distinguish circuit peering from VNet gateway. |
| CONN-ER-09 | Circuit/VNet relationship | Design exercise | Draw gateway connection and ownership boundary. |
| CONN-ER-10 | Route advertisements | Design exercise | Allowed/filtered prefixes and normal/failed route choice. |
| CONN-ER-11 | Payload encryption | Design exercise | Compare IPsec overlay and MACsec applicability. |
| CONN-ER-12 | Fast failure detection | Design exercise | Explain BFD detection scope and dependencies. |
| CONN-ER-13 | Circuit diagnosis | Design exercise | Request provider, peering, route and application evidence. |

## CONN-VWAN — Managed hubs

[Domain chapter](../domains/02-connectivity.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| CONN-VWAN-01 | WAN SKU choice | Design exercise | Profile review and connectivity decision table. |
| CONN-VWAN-02 | Hub architecture | Terraform-backed | Root vWAN/hub/connection shape plus architecture diagram. |
| CONN-VWAN-03 | Hub resource | Terraform-backed | Root vhub module. |
| CONN-VWAN-04 | Gateway scale | Reference configuration | Module scale-unit input and sizing worksheet. |
| CONN-VWAN-05 | Hub gateway | Terraform-backed | Hybrid profile adds the vHub VPN gateway. |
| CONN-VWAN-06 | Hub routes | Terraform-backed | Connections and routing intent; effective paths need live verification. |
| CONN-VWAN-07 | Third-party hub appliance | Design exercise | External appliance ownership/integration exercise. |

## APP-LB — Transport delivery and DNS selection

[Domain chapter](../domains/03-delivery.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| APP-LB-01 | Capability selection | Design exercise | Delivery comparison table. |
| APP-LB-02 | Transport use case | Design exercise | Regional/global/application decision worksheet. |
| APP-LB-03 | LB SKU/tier choice | Reference configuration | Standard internal root example plus reference public variant. |
| APP-LB-04 | Public/internal frontends | Reference configuration | Root internal LB and public-LB reference HCL. |
| APP-LB-05 | Regional/cross-region choice | Design exercise | Delivery design comparison; cross-region LB not deployed. |
| APP-LB-06 | LB declaration | Terraform-backed | Root Standard internal load balancer and producer example. |
| APP-LB-07 | Traffic Manager | Terraform-backed | Independent two-region example with routing methods. |
| APP-LB-08 | Appliance insertion | Design exercise | Gateway Load Balancer worksheet; no licensed appliance implied. |
| APP-LB-09 | Transport rule | Terraform-backed | Root HTTP transport rule and probe. |
| APP-LB-10 | Inbound NAT rule | Reference configuration | Current rule-v2 reference HCL, not VMSS NAT-pool deployment. |
| APP-LB-11 | Explicit outbound SNAT | Reference configuration | Public Standard LB outbound-rule reference; root NAT is a separate mechanism. |

## APP-GW — Regional HTTP proxy

[Domain chapter](../domains/03-delivery.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| APP-GW-01 | Gateway capability choice | Design exercise | Regional delivery decision worksheet. |
| APP-GW-02 | Gateway use case | Design exercise | Compare TLS/WAF requirements with transport LB. |
| APP-GW-03 | Capacity choice | Terraform-backed | Root autoscale inputs; module fixed-capacity alternative is reference. |
| APP-GW-04 | Backend pool | Terraform-backed | Actual root web-VM private addresses are wired. |
| APP-GW-05 | Health probe | Terraform-backed | Module probe configuration; service response NOT RUN. |
| APP-GW-06 | Listener | Terraform-backed | HTTP teaching listener and optional HTTPS reference inputs. |
| APP-GW-07 | Request routing | Terraform-backed | Module request-routing rules. |
| APP-GW-08 | Backend settings | Terraform-backed | Explicit backend HTTP configuration. |
| APP-GW-09 | TLS boundary | Reference configuration | Existing certificate/identity/hostname inputs; backend TLS design separate. |
| APP-GW-10 | Header/path rewrite | Terraform-backed | Module rewrite configuration; behavior needs a request test. |

## APP-FD — Global HTTP delivery

[Domain chapter](../domains/03-delivery.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| APP-FD-01 | Capability selection | Design exercise | Compare global frontend, regional proxy and DNS routing. |
| APP-FD-02 | Use-case choice | Design exercise | Delivery decision worksheet. |
| APP-FD-03 | Tier selection | Terraform-backed | Independent example uses Premium for private origin. |
| APP-FD-04 | Endpoint/origin/routes | Terraform-backed | Independent Front Door root. |
| APP-FD-05 | TLS legs | Terraform-backed | Managed frontend and origin hostname/certificate settings; live handshake unverified. |
| APP-FD-06 | Caching behavior | Terraform-backed | Example route cache configuration; runtime cache evidence unverified. |
| APP-FD-07 | Global acceleration | Design exercise | Explain service choice and path; no latency benchmark claimed. |
| APP-FD-08 | Rules and redirects | Terraform-backed | Example header/cache rules and HTTPS redirect; arbitrary URL-rewrite variants remain a design extension. |
| APP-FD-09 | Private origin | Terraform-backed | Private Link request configured; manual approval required. |

## PRIVATE-LINK — Consumer/provider private service

[Domain chapter](../domains/04-private-access.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| PRIVATE-LINK-01 | Endpoint plan | Design exercise | DNS/route/identity worksheet. |
| PRIVATE-LINK-02 | Endpoint resource | Terraform-backed | Root Blob endpoint and independent consumer example. |
| PRIVATE-LINK-03 | Endpoint access | Reference configuration | Layered authorized-private/public evidence procedure. |
| PRIVATE-LINK-04 | Provider service | Terraform-backed | Independent producer LB, service and consumer root. |
| PRIVATE-LINK-05 | DNS integration | Terraform-backed | Root zone group/links and example DNS records. |
| PRIVATE-LINK-06 | External client access | Reference configuration | Hybrid DNS/route worksheet; no real branch client supplied. |

## PRIVATE-SE — Service destination policy

[Domain chapter](../domains/04-private-access.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| PRIVATE-SE-01 | Endpoint selection | Design exercise | Private/service-endpoint comparison. |
| PRIVATE-SE-02 | Service endpoint | Terraform-backed | Root subnet settings and independent policy example. |
| PRIVATE-SE-03 | Destination policy | Terraform-backed | Independent storage-destination restriction example. |
| PRIVATE-SE-04 | Authorized access | Terraform-backed | Example client read roles to both accounts; network outcomes NOT RUN. |

## SEC-NSG — Network rule administration

[Domain chapter](../domains/05-security.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| SEC-NSG-01 | NSG resource | Terraform-backed | Root NSG modules. |
| SEC-NSG-02 | NSG attachment | Terraform-backed | Root subnet association maps. |
| SEC-NSG-03 | ASG resource | Reference configuration | Reference HCL declares an application group. |
| SEC-NSG-04 | ASG NIC attachment | Reference configuration | Reference NIC/group association; not a root workload change. |
| SEC-NSG-05 | Directional rules | Terraform-backed | Root scoped administration, workload and probe rules. |
| SEC-NSG-06 | VNet flow configuration | Terraform-backed | Opt-in monitoring targets VNets, not NSGs. |
| SEC-NSG-07 | Flow interpretation | Reference configuration | Synthetic record worksheet and schema link. |
| SEC-NSG-08 | IP flow diagnosis | Reference configuration | Future Network Watcher command template. |
| SEC-NSG-09 | Remote administration | Terraform-backed | Optional Bastion plus scoped RDP source configuration. |
| SEC-NSG-10 | AVNM administration | Terraform-backed | Independent AVNM security configuration and deployment. |

## SEC-FW — Routed inspection

[Domain chapter](../domains/05-security.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| SEC-FW-01 | Firewall selection | Design exercise | Control-layer and cost comparison. |
| SEC-FW-02 | Firewall SKU choice | Design exercise | Standard implementation plus requirements worksheet. |
| SEC-FW-03 | Inspection design | Design exercise | Forward/return path diagram and flow table. |
| SEC-FW-04 | Firewall resource | Terraform-backed | Secured hub profile. |
| SEC-FW-05 | Rule collections | Terraform-backed | Scoped private network and explicit outbound rules. |
| SEC-FW-06 | Policy administration | Terraform-backed | Firewall policy and rule-collection resources; broad manager operations not claimed. |
| SEC-FW-07 | Secured managed hub | Terraform-backed | vHub Firewall and routing intent. |

## SEC-WAF — HTTP request policy

[Domain chapter](../domains/05-security.md) · [Configuration patterns](configuration-patterns.md) · [Design worksheets](../scenarios/design-exercises.md)

| ID | Topic index | Coverage | Configuration or evidence boundary |
|---|---|---|---|
| SEC-WAF-01 | WAF capability choice | Design exercise | Delivery/security worksheet. |
| SEC-WAF-02 | WAF architecture | Design exercise | Regional versus global policy boundary. |
| SEC-WAF-03 | Policy mode | Terraform-backed | Root configurable Detection/Prevention. |
| SEC-WAF-04 | Front Door rules | Terraform-backed | Independent Premium WAF policy. |
| SEC-WAF-05 | App Gateway rules | Terraform-backed | Root WAF policy/rules. |
| SEC-WAF-06 | Policy resource | Terraform-backed | App Gateway and Front Door configurations. |
| SEC-WAF-07 | Policy association | Terraform-backed | Policies attached to the corresponding delivery resources. |

**Completeness:** 136 rows across 16 ordered subgroups. Completeness of mapping is not completeness of deployed coverage. Reconcile IDs against the dated study guide when Microsoft changes its outline; do not silently relabel old evidence.
