# VPN and the branch simulation

The hybrid profile creates a vWAN-side VPN gateway and a VNet VPN gateway in the Azure-hosted branch. VPN site, connection and local-network-gateway resources connect those sides. Inspect BGP ASN, peer and advertised-prefix values together.

The branch's location inside Azure is a deliberate teaching simplification. It cannot establish interoperability with a physical firewall, ISP path, NAT-T device, or an actual branch DNS service. These are [external VPN design tasks](../scenarios/design-exercises.md#external-vpn-and-client-design).

For a future connection test, first establish IKE/IPsec status, then BGP state and route advertisements, then a transport request and return path. An established VPN alone is not end-to-end validation. Never include the PSK in an evidence file or command transcript.

The independent [P2S example](../../examples/point-to-site-vpn/README.md) uses a different state, gateway and client-address pool. It is not another toggle in the root. Current SKU and migration notes are in [defaults and lifecycle](../reference/defaults-and-skus.md).
