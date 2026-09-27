# Boundaries and tradeoffs

This repository prioritizes understandable network configurations. It is not a production landing zone or a managed service.

- Root profiles share a Terraform root; they are alternative footprints, not isolated concurrent environments.
- The branch is simulated in Azure. External device interoperability is not demonstrated.
- Route Server and vWAN are separate Spoke1 attachment choices. A synthetic route does not imply a deployed destination.
- Front Door origin approval, P2S clients, certificates, external DNS, ExpressRoute and third-party appliances have dependencies outside their Terraform configuration.
- WAF modes, allowed hostnames and administration sources need scenario-specific review.
- Multiple services bill while no learner is generating traffic. Stopping a VM does not remove a gateway, endpoint, disk, plan or log charge.
- Offline schema/mock checks cannot prove SKU availability, quota, deployment permission, provisioning, route convergence or traffic behavior.
- Every current Azure deployment and live check is NOT RUN. Read [validation status](../../docs/validation-status.md) for exact local results.

Use [design exercises](../scenarios/design-exercises.md) for costly or externally dependent topics. Use [cost planning](../reference/cost-model.md) before any future operation.
