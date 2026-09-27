## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_defaults"></a> [defaults](#input\_defaults) | Default tags to apply. | `map(string)` | `{}` | no |
| <a name="input_extra"></a> [extra](#input\_extra) | Additional tags to merge over defaults. | `map(string)` | `{}` | no |
| <a name="input_required_keys"></a> [required\_keys](#input\_required\_keys) | Required tag keys that must exist and be non-empty. | `set(string)` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_tags"></a> [tags](#output\_tags) | Merged and validated tags. |
