# Storage and private service boundaries

The main private-DNS profile owns a sample storage account, Blob private endpoint and optional private DNS association. Its public-network access is disabled. That setting does not grant a user or VM a Blob data role.

The monitoring module uses a separate account with default-deny network rules and trusted service writes. Its flow-log support requirements differ from the private-only sample. Do not describe every repository storage account as public-network-disabled.

The independent service-endpoint-policy example contrasts allowed and forbidden storage destinations with comparable client authorization. It owns a second resource group for the allowed destination scope. The Private Link service example exposes a custom backend rather than a Microsoft-managed Blob subresource.

For future evidence, pair DNS and selected route with endpoint approval and an authorized data operation. Public-endpoint denial must be a network result under an otherwise authorized identity. [Private access curriculum](../domains/04-private-access.md)
