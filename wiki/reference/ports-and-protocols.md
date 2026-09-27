# Flow inventory

Review flows by purpose and selected path, not by copying an unrestricted port list.

| Purpose | Typical lab protocol | Review boundary |
|---|---|---|
| DNS | UDP/TCP 53 | Resolver route, target server, zone/ruleset links |
| Web teaching backends | TCP 80 | Scoped client/probe source and actual guest listener |
| HTTPS | TCP 443 | Allowed hostname, certificate and proxy/origin boundary |
| Windows administration | TCP 3389 | Scoped administration sources or Bastion, no Internet-wide rule |
| BGP | TCP 179 | Peer endpoints, ASN and routing control plane |
| VPN | IKE/IPsec/NAT-T as configured | Both peers, public path and negotiated policy |
| Windows activation | TCP 1688 to configured KMS names | Explicit Firewall rule, not broad Internet permission |
| Guest agent host channel | Azure platform address and documented ports | Platform dependency, not application egress proof |

The root Firewall separately permits configured public HTTPS names, the Microsoft WindowsUpdate tag, KMS names, and optional AzureMonitor service-tag HTTPS when monitoring is enabled. Its private network rules are a different scope.

WindowsUpdate is a service-managed FQDN tag. Although configured with HTTPS/443 in a Firewall application rule, tag behavior can permit required HTTP endpoints. Do not describe every permitted flow as HTTPS-only. [FQDN tags](https://learn.microsoft.com/en-us/azure/firewall/fqdn-tags)

Supported Windows guest agents use their platform channel; do not solve an extension problem by adding a broad Blob or GitHub allowlist without evidence. [Windows extension network access](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/features-windows#network-access)

Live flow and guest-agent behavior remains NOT RUN.
