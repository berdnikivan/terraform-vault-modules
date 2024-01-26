output "role_name" {
  description = "Role name"
  value       = vault_kubernetes_auth_backend_role.k8s-role.role_name
}
