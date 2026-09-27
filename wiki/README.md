# Azure networking learning wiki

Begin with the [book](book.md). It connects five exam domains to configurations, packet paths, decisions, and evidence. The [coverage matrix](reference/az-700-alignment.md) maps every ordered objective in the July 2026 outline to an artifact and an honest coverage label.

![Documentation and learning map](../docs/diagrams/learning-map.svg)

*The diagram separates the main profiles, independent examples, and design exercises. All live Azure outcomes remain NOT RUN.*

| Read for | Pages |
|---|---|
| A guided course | [Book](book.md), [Core](domains/01-core.md), [Connectivity](domains/02-connectivity.md), [Delivery](domains/03-delivery.md), [Private access](domains/04-private-access.md), [Security](domains/05-security.md) |
| A configuration | [Scenario index](scenarios/README.md), [minimal](scenarios/minimal-cost.md), [secured hub](scenarios/secured-hub-firewall.md), [VPN](scenarios/vpn-bgp.md), [Route Server](scenarios/route-server-bgp.md), [DNS](scenarios/private-endpoints-dns.md), [delivery](scenarios/edge-services.md), [independent examples](scenarios/independent-examples.md) |
| A design decision | [Addressing](architecture/network-topology.md), [vWAN](architecture/vwan-and-vhub.md), [BGP](architecture/routing-and-bgp.md), [traffic](architecture/traffic-flows.md), [DNS](architecture/dns-and-private-link.md), [security](architecture/security-model.md), [design exercises](scenarios/design-exercises.md) |
| A diagnostic method | [Testing guide](testing/lab-testing-guide.md), [evidence matrix](testing/test-matrix.md), [routes](testing/route-validation.md), [DNS](testing/dns-validation.md), [troubleshooting](testing/troubleshooting.md) |
| A reference | [Inputs](reference/variables.md), [outputs](reference/outputs.md), [profiles](reference/feature-matrix.md), [cost](reference/cost-model.md), [state](reference/state-and-secrets.md), [lifecycle](reference/defaults-and-skus.md), [source register](reference/sources.md) |
| Maintaining this repo | [Modules](modules/README.md), [review checklist](../docs/operations/review-checklist.md), [contributing](../CONTRIBUTING.md), [validation status](../docs/validation-status.md) |

## Read the coverage labels correctly

**Terraform-backed** means the repository contains wiring for the specified part of a topic. **Reference configuration** means a concrete configuration or diagnostic procedure exists but external inputs, clients, approval, or additional infrastructure are still required. **Design exercise** means the learner produces a reasoned design, not an implemented service.

None of these labels means a live test passed. Keep configuration checks, synthetic examples, and real Azure evidence separate. The [testing guide](testing/lab-testing-guide.md) defines the evidence contract.

The repository uses Terraform 1.16.4 and AzureRM 4.57.0. Main-root inputs use `ctx` and `deploy`; independent examples have their own interfaces. Do not copy a main-root profile into an example.
