# Troubleshooting by layer

| Symptom | Investigate first | Avoid this false fix |
|---|---|---|
| Input rejected | Selected profile, dependent flags, CIDR ranges | Disabling validation |
| Azure plan unexpectedly changes resources | Root/state/profile identity and input precedence | Applying before reviewing removals |
| Name resolves publicly | Client resolver, CNAME, zone link and cache | Changing the app URL to a private IP |
| Private IP resolves but request fails | Route, endpoint approval, NSG and authorized data role | Enabling public access |
| No Firewall log | Actual next hop and diagnostic destination | Claiming a timeout proves policy denial |
| VPN is up, traffic fails | BGP/prefixes, return path, NSG | Rotating the PSK without evidence |
| BGP is up, ping fails | Destination existence and selected route | Treating the synthetic prefix as a real host |
| 502 from proxy | Probe path/host, backend service, TLS and NSG | Disabling WAF broadly |
| VM extension fails | Platform channel, guest logs and explicit egress | Adding an unrestricted Internet allow rule |
| Flow logs absent | VNet target, watcher region, storage rules, permissions and delay | Configuring new retired NSG flow logs |
| P2S login fails | Tenant/audience/issuer, authorization and client profile | Changing subnet routes first |
| Cleanup leaves resources | Correct state/root, shared vs owned resource list | Deleting an entire shared watcher group |

Use one hypothesis at a time and predict which observation would disprove it. Record the source/time of each signal. A mock test failure is a code problem; an unavailable Azure SKU or real client fault requires live investigation in a separately authorized environment.

[Evidence contract](lab-testing-guide.md) · [Route procedure](route-validation.md) · [DNS procedure](dns-validation.md)
