# Editable engineering diagrams

Each Mermaid source has a matching rendered SVG with an accessible title and description. These diagrams describe configuration and teaching boundaries; they are not discovered resource inventories.

| Diagram | Source | Meaning |
|---|---|---|
| [minimal-starter](minimal-starter.svg) | [Mermaid](minimal-starter.mmd) | Minimal profile: peered spokes and an isolated branch |
| [learning-map](learning-map.svg) | [Mermaid](learning-map.mmd) | AZ-700 learning and documentation map |
| [address-allocation](address-allocation.svg) | [Mermaid](address-allocation.mmd) | Default Azure Network Lab address allocation |
| [vwan](vwan.svg) | [Mermaid](vwan.mmd) | Virtual WAN secured-hub profile and optional hybrid branch |
| [route-server](route-server.svg) | [Mermaid](route-server.mmd) | Route Server control plane and NVA data path |
| [traffic-egress](traffic-egress.svg) | [Mermaid](traffic-egress.mmd) | Separate forward, return, and outbound traffic cases |
| [dns-private-access](dns-private-access.svg) | [Mermaid](dns-private-access.mmd) | Hybrid DNS query path and Blob private endpoint connection |
| [delivery-security](delivery-security.svg) | [Mermaid](delivery-security.mmd) | Application delivery services and security boundaries |
| [monitoring](monitoring.svg) | [Mermaid](monitoring.mmd) | Monitoring signals and evidence boundaries |

Edit the Mermaid source and regenerate its SVG together. The local quality checks require both files. Review the image at reading size for clipped labels, crossing arrows, and ambiguous directions. Solid application paths and dashed control/return/reference paths are explained in each caption; do not infer semantics from color alone.

## Reproduce a render locally

Use Mermaid CLI **12.0.0** and an available compatible Chromium executable. Run the repository helper with actual local paths:

```powershell
pwsh ./scripts/Render-Diagrams.ps1 -MermaidCli '<path-to-mmdc>' -BrowserExecutable '<path-to-compatible-chromium>'
```

The helper renders the paired SVGs from this directory. To inspect PNGs without committing them, select `-Format png` and an ignored scratch `-OutputDirectory`. Browser/tool installation is a local tooling concern, not Azure deployment.

Review at ordinary reading size and full SVG scale. Keep source, title, description and prose caption synchronized.
