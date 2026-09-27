# Compute modules

Optional Windows workload VMs and RRAS NVAs are teaching hosts. Workload flags and `nvas` require a private `admin_password`; minimal does not. Terraform state retains sensitive values, so the sensitive marker is not encryption. [State guidance](../reference/state-and-secrets.md)

The application-delivery profile wires two web VM private IPs into its backends and supplies guest IIS configuration. Successful schema or mock checks do not prove guest extension execution or a healthy HTTP endpoint.

The Route Server profile creates the RRAS NVAs without workload VMs. The Spoke1 NVA advertises a synthetic prefix; the branch NVA is not automatically tunneled to it. Record guest forwarding and both BGP sessions before claiming useful transit.

Guest provisioning depends on platform communication and explicit outbound paths. Supported Windows guest agents use documented platform channels; avoid inventing broad download exceptions. [Microsoft Windows extension access](https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/features-windows#network-access)

All guest bootstrapping and execution is NOT RUN for this update.
