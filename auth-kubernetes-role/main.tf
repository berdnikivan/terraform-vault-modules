# Backend role
resource "vault_kubernetes_auth_backend_role" "k8s-role" {
  backend                          = var.auth_backend_path
  role_name                        = var.role_name
  bound_service_account_names      = var.bound_service_account_names
  bound_service_account_namespaces = var.bound_service_account_namespaces
  audience                         = var.audience
  alias_name_source                = var.alias_name_source
  # Common Token Arguments
  token_ttl               = var.token_ttl
  token_max_ttl           = var.token_max_ttl
  token_period            = var.token_period
  token_policies          = concat(var.token_policies, [var.role_name])
  token_bound_cidrs       = var.token_bound_cidrs
  token_explicit_max_ttl  = var.token_explicit_max_ttl
  token_no_default_policy = var.token_no_default_policy
  token_num_uses          = var.token_num_uses
  token_type              = var.token_type
}

# Policies
data "vault_policy_document" "policy_document" {
  dynamic "rule" {
    for_each = var.k8s_policy_rules
    content {
      path         = lookup(rule.value, "path")
      capabilities = lookup(rule.value, "capabilities")
      description  = rule.key == 0 ? "Terraform managed policy for Kubernetes role '${vault_kubernetes_auth_backend_role.k8s-role.role_name}'" : ""
    }
  }
}

resource "vault_policy" "k8s-policy" {
  name   = vault_kubernetes_auth_backend_role.k8s-role.role_name
  policy = data.vault_policy_document.policy_document.hcl
}
