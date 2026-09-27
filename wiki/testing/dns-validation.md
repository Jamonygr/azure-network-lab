# Future DNS and private-access diagnosis

Commands below generate queries or traffic and are **NOT RUN**. Run future tests from a known private-connected client using the intended resolver.

```powershell
$storage = '<actual-storage-name>'
Resolve-DnsName "$storage.blob.core.windows.net"
Test-NetConnection "$storage.blob.core.windows.net" -Port 443
# For the external-forwarding case, query the known inbound resolver:
Resolve-DnsName "$storage.blob.core.windows.net" -Server '<resolver-inbound-private-ip>'
```

Record the client resolver, full CNAME chain, final A record and endpoint IP. A public answer may indicate the wrong resolver, missing link/record, cache or forwarding configuration. A correct private answer followed by failure points to routing, service approval, policy or identity instead.

The default empty forwarding rule map is intentional. Configure a real reachable server before expecting `branch.example.` to resolve. Never point a forwarding rule into a loop through the same resolver's inbound endpoint.

A TCP success does not establish a Blob permission. A future authenticated operation can use an identity explicitly granted the necessary data role:

```powershell
az storage container list --account-name '<actual-storage-name>' --auth-mode login --output table
```

No data-plane role is implied by ordinary Contributor. For a public-access negative test, use the same authorized identity and distinguish an explicit network restriction from an authentication error or timeout. Do not open public access as a troubleshooting shortcut. [DNS paths](../architecture/dns-and-private-link.md)
