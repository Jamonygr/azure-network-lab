# Security review checklist

Review the selected configuration, not the maximum possible topology.

- Require explicit subscription/context, nonoverlapping address spaces and clear state ownership.
- Restrict management sources. Do not add Internet-wide RDP or a wildcard Firewall rule to hide a failing test.
- Verify both route directions before claiming Firewall inspection.
- Separate DNS, endpoint approval, public network settings and data RBAC.
- Treat sample HTTP as a teaching mode with no credentials or sensitive application data. Configure real TLS dependencies before changing that scope.
- Confirm WAF policy association and intended mode; a configured policy is not runtime evidence.
- Reuse shared Network Watcher deliberately and track the child resources owned by this state.
- Keep monitoring storage's service-managed write requirements distinct from private-only sample storage.
- Protect state/plans, avoid secret transcripts, and review retained resources before cleanup.
- Record live deployment and test outcomes as NOT RUN until measured.

[Security policy](../../SECURITY.md) · [State](state-and-secrets.md) · [Evidence matrix](../testing/test-matrix.md)
