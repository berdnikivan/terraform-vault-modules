resource "random_id" "id" {
  byte_length = 4
}

data "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.cluster_location
  project  = var.cluster_project
}

data "google_client_config" "default" {
}

data "kubernetes_secret" "vault_sa_token" {
  metadata {
    name      = kubernetes_secret_v1.vault_sa_token.metadata[0].name
    namespace = kubernetes_secret_v1.vault_sa_token.metadata[0].namespace
  }
}

# Vault SA (https://github.com/banzaicloud/bank-vaults/blob/main/operator/deploy/rbac.yaml)
resource "kubernetes_service_account_v1" "vault" {
  metadata {
    name = "vault-${random_id.id.hex}"
    namespace = var.sa_namespace
  }
}

resource "kubernetes_secret_v1" "vault_sa_token" {
  metadata {
    name = "${kubernetes_service_account_v1.vault.metadata[0].name}-sa-token"
    namespace = kubernetes_service_account_v1.vault.metadata[0].namespace
    annotations = {
        "kubernetes.io/service-account.name" = kubernetes_service_account_v1.vault.metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_role_v1" "vault" {
  metadata {
    name = kubernetes_service_account_v1.vault.metadata[0].name
  }
  rule {
    api_groups     = [""]
    resources      = ["secrets"]
    resource_names = ["foo"]
    verbs          = ["*"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "update", "patch"]
  }
}

resource "kubernetes_role_binding_v1" "vault" {
  metadata {
    name      = kubernetes_service_account_v1.vault.metadata[0].name
    namespace = var.sa_namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "vault"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "vault"
    namespace = var.sa_namespace
  }
}

resource "kubernetes_cluster_role_binding_v1" "vault" {
  metadata {
    name = kubernetes_service_account_v1.vault.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.vault.metadata[0].name
    namespace = var.sa_namespace
  }
}

# Auth backend
resource "vault_auth_backend" "auth_backend" {
  type = "kubernetes"
  path = var.auth_path
}
  
resource "vault_kubernetes_auth_backend_config" "auth_backend_config" {
  backend                = vault_auth_backend.auth_backend.path
  kubernetes_host        = "https://${data.google_container_cluster.gke.endpoint}"
  kubernetes_ca_cert     = data.kubernetes_secret.vault_sa_token.data["ca.crt"]
  token_reviewer_jwt     = data.kubernetes_secret.vault_sa_token.data.token
  disable_iss_validation = var.disable_iss_validation
  disable_local_ca_jwt   = var.disable_local_ca_jwt
  issuer                 = var.issuer
  pem_keys               = var.pem_keys
}
