# Validation status

Exam baseline: AZ-700 skills effective **2026-07-27**. Validation completed **2026-09-27 at 11:34 UTC**, on Windows with PowerShell **7.6.6**.

**All 46 local validation gates passed. Azure deployment and live acceptance were NOT RUN.** The source was checked in an isolated copy, then compared with the working source before publication. Existing local state, real variable files, credentials and saved plans were excluded. No Azure login, resource inspection, refresh, deployment or destruction was performed.

| Check | Status | Observed result |
| --- | --- | --- |
| Terraform formatting | PASS | Source-only recursive check |
| Backend-free initialization and schema validation | PASS | Main root and all seven independent examples |
| Mocked Terraform plans | PASS | **52 passed, 0 failed**: 28 root/module/profile runs and 24 example runs |
| Windows PowerShell tests | PASS | **22 passed, 0 failed**: source isolation, native failures, and NVA command-line/AST regression checks |
| Python checker tests | PASS | **3 passed, 0 failed** |
| Terraform lint | PASS | TFLint 0.63.1, bundled Terraform ruleset |
| Infrastructure security | PASS | Trivy 0.72.0; no unhandled HIGH/CRITICAL findings across all seven profiles and examples |
| Secret scan | PASS | Gitleaks 8.28.0, redacted output, source-only directory |
| Markdown and internal links | PASS | 111 Markdown pages, 959 local links/anchors |
| Public documentation links | PASS | 51 referenced Microsoft/HashiCorp/security documentation URLs returned HTTP 200 |
| Generated Terraform references | PASS | 35 configuration references plus navigation index, terraform-docs 0.24.0 |
| Diagrams | PASS | Eight Mermaid/SVG pairs rendered with Mermaid CLI 12.0.0; PNG visual review completed |
| Pipeline exclusion | PASS | No GitHub Actions or Azure DevOps pipeline definitions |
| Azure deployments and live acceptance | NOT RUN | Explicitly outside this update |

The mocked suite covers minimal/legacy behavior, actual profile inputs, CIDRs, conditional credentials, unsupported topology combinations, explicit egress, NSG sources, scoped Firewall rules, DNS forwarding/loop rejection, Application Gateway backends/TLS/WAF, monitoring, example cost gates and scenario contracts. The Windows NVA tests parse the real command line and embedded scripts without executing RRAS installation. Probe shell/Python syntax was also checked without running guest requests.

## Scope of the scanner result

Two narrowly annotated Storage declarations suppress `AVD-AZU-0010`: the private-only root account and the endpoint-policy example deliberately **deny trusted-service bypass**. Enabling `AzureServices` solely to satisfy that recommendation would weaken their intended restrictions. Flow-log storage has its separate documented trusted-service requirement. No other security findings are hidden by a repository-wide ignore list. Lower-severity findings are outside the HIGH/CRITICAL gate.

TFLint retains three narrow unused-declaration annotations for compatibility-only module context inputs and the always-enforced address validation input. Child-module duplicate provider/version rules are disabled in its configuration; root/example constraints and provider schemas are checked by Terraform. Security scanning used installed Trivy rules with updates, telemetry and version checks disabled; it is not a live Azure security assessment.

## Reproduce locally

```powershell
pwsh ./scripts/Test-Offline.ps1
```

Prerequisites: Terraform **1.16.4**, PowerShell **7+**, Pester **5.7.1+**, Python **3.10+**, terraform-docs **0.24.0**, TFLint, Trivy and Gitleaks. The complete suite was executed on Windows; another host OS was not tested. AzureRM **4.57.0** and random **3.7.2** remain locked. Missing tools, failed native commands and zero executed mock tests fail the runner.

The runner creates a fresh source-only temporary directory. Initialization may download locked HashiCorp providers unless a local mirror is configured; no Azure credentials are needed. Security scanning receives synthetic context only inside that temporary copy, after Terraform tests. A sanitized status-only summary is saved to ignored `.local/validation-summary.json`; detailed command output remains local. Temporary source snapshots are retained for troubleshooting.

Regenerate references with `pwsh ./scripts/Update-TerraformReference.ps1`; use `-Check` to detect stale output. Regenerate diagrams with `pwsh ./scripts/Render-Diagrams.ps1` and an existing renderer/browser, following the [diagram guide](diagrams/README.md). These helpers install nothing automatically.

## Remaining live evidence

Regional availability, platform provisioning, BGP convergence, DNS/data paths, managed private endpoint approval, certificates, VPN clients, WAF/Firewall decisions, guest probes, Flow Logs delivery and residual-resource cleanup still require a future operator-run exercise. All remain **NOT RUN**. A mocked plan establishes configuration behavior, not live connectivity. See the [future evidence contract](../wiki/testing/lab-testing-guide.md).
