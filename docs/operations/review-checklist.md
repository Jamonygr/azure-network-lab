# Review Checklist

This checklist is for maintainers reviewing architecture, Terraform, or documentation changes.

## Architecture

- The topology remains explainable from the README and wiki overview.
- Optional services are controlled by feature flags rather than manual code edits.
- Azure platform constraints are documented near the related scenario.
- Address spaces, ASNs, and route intent stay consistent across code and docs.

## Terraform

- Root files orchestrate modules; modules own resource implementation details.
- Resource names follow the shared prefix and naming convention.
- Tags flow through `module.tags` and the shared `ctx` object.
- Conditional resources avoid invalid references when their feature flag is disabled.
- Variable validations catch common misconfiguration before provider calls.

## Security

- No local state, plan, log, or variable files are tracked.
- Public network access is disabled by default for private endpoint examples.
- Administrative access is scoped to lab networks or Bastion-based workflows.
- Any new secrets are marked `sensitive` and documented outside committed examples.

## Documentation

- README remains a quick path to deploy, validate, and clean up.
- Wiki pages are updated when resource behavior changes.
- Cost-bearing features are called out where they are enabled.
- Commands use placeholders instead of environment-specific values.
