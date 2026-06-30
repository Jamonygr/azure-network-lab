# Security

Azure Network Lab is a learning environment, but it still deploys real cloud resources. Treat credentials, subscription IDs, public IPs, and Terraform state with the same care you would use for any other infrastructure repository.

## Reporting Issues

Please do not open public issues that include secrets, subscription-specific values, public IPs, or exported state. Redact sensitive values before sharing logs or command output.

## Secret Handling

- Do not commit `terraform.tfvars`, state files, plan files, logs, or generated credentials.
- Use environment variables, Azure Key Vault, or a secure local secret manager for real values.
- Rotate VM admin passwords and VPN shared keys after demos, workshops, or shared lab use.
- Prefer remote state with encryption, versioning, soft delete, and locking for collaborative use.

## Cloud Safety Notes

- The default architecture can create cost-bearing network services such as Azure Firewall, Route Server, VPN Gateway, DNS Private Resolver, and Application Gateway.
- Restrict RDP, HTTP, and ICMP rules before adapting this lab beyond isolated training.
- Review `wiki/reference/hardening.md` before using the design as a starting point for a longer-lived environment.
- Run `terraform destroy` when the lab is no longer needed.
