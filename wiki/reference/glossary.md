# Working glossary

| Term | Meaning in this repository |
|---|---|
| Profile | Input overlay for the main root; not a state boundary |
| Example root | Independent Terraform directory owning its resources/state |
| Control plane | Service/resource configuration or route distribution |
| Data plane | Actual application packets and service requests |
| BGP | Route exchange; established sessions do not guarantee a desired path |
| UDR | Explicit route attached through a route table/subnet association |
| SNAT | Source translation used for outbound flows |
| Private endpoint | Consumer network interface for a particular service connection |
| Private Link service | Provider-side custom service exposure |
| Service endpoint | Subnet-based access to a supported service endpoint |
| Ruleset link | Selects DNS forwarding for a VNet; not a route |
| Zone link | Makes a private namespace visible through the linked VNet's resolver path |
| Health probe | A configured test of a particular target/protocol, not all application behavior |
| WAF | HTTP-layer policy; distinct from route and transport filtering |
| Synthetic evidence | Invented teaching data that must not be called a real observation |
| NOT RUN | No corresponding live check was performed |
| Terraform-backed | Wiring exists; not a statement that deployment succeeded |

[Book](../book.md) · [Architecture](../architecture/overview.md)
