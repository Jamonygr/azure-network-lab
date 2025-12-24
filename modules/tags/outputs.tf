output "tags" {
  description = "Merged and validated tags."
  value       = local.tags

  precondition {
    condition     = length(local.missing) == 0
    error_message = "Missing required tag keys: ${join(", ", sort(local.missing))}"
  }

  precondition {
    condition     = length(local.empty_keys) == 0
    error_message = "Required tag values must be non-empty: ${join(", ", sort(local.empty_keys))}"
  }
}
