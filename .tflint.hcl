plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# Child modules inherit the root constraints; duplicate provider version blocks
# in every module make maintenance harder without changing initialization.
rule "terraform_required_version" {
  enabled = false
}
rule "terraform_required_providers" {
  enabled = false
}
