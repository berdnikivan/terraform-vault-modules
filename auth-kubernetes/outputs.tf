output "path" {
    description = "The path to mount the auth method"
    value = vault_auth_backend.auth_backend.path
}
