locals {
  tags       = merge(var.defaults, var.extra)
  missing    = setsubtract(var.required_keys, keys(local.tags))
  empty_keys = [for key in var.required_keys : key if length(trimspace(lookup(local.tags, key, ""))) == 0]
}
