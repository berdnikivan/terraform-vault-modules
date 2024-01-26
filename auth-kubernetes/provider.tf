terraform {
  required_version = ">= 1.3.3"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.41.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.14.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.10.0"
    }
  }
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.gke.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate,
  )
  experiments {
    manifest_resource = true
  }
}