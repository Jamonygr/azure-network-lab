variable "required_keys" {
  description = "Required tag keys that must exist and be non-empty."
  type        = set(string)
}

variable "defaults" {
  description = "Default tags to apply."
  type        = map(string)
  default     = {}
}

variable "extra" {
  description = "Additional tags to merge over defaults."
  type        = map(string)
  default     = {}
}
