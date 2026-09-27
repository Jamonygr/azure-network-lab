# Address and BGP teaching values

The default main topology uses Spoke1 10.1.0.0/16, Spoke2 10.2.0.0/16, branch 192.168.0.0/16 and hub 10.10.0.0/23. [Subnet ledger](../architecture/network-topology.md)

The Spoke1 NVA's default teaching private address is 10.1.8.10 and ASN is 65501. Root Route Server outputs expose its actual configured instance addresses/ASN. The branch-side gateway uses the root's configured ASN; inspect current wiring before comparing it with an external device.

The 10.100.0.0/16 NVA advertisement is synthetic. No backend in that range is created. Route learning and destination reachability are separate learning outcomes. On-prem NVA presence does not imply a tunnel to the Spoke1 NVA.

When changing parent CIDRs, inspect all derived offsets and peer references. Do not carry the diagram's literal IPs into a custom deployment. [BGP exercise](../scenarios/route-server-bgp.md)
