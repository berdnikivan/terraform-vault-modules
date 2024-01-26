# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
    description = "Kubernetes cluster name"
    type        = string
}

variable "cluster_location" {
    description = "Kubernetes cluster location"
    type        = string
}

variable "cluster_project" {
    description = "GCloud project ID"
    type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# Generally, these values won't need to be changed.
# ---------------------------------------------------------------------------------------------------------------------
variable "disable_local_ca_jwt" {
    description = "PEM encoded CA cert for use by the TLS client used to talk with the Kubernetes API"
    type        = bool
    default     = true
}
variable "disable_iss_validation" {
    description = "Disable JWT issuer validation. Allows to skip ISS validation. Requires Vault v1.5.4+ or Vault auth kubernetes plugin v0.7.1+"
    type        = bool
    default     = false
}

variable "issuer" {
    description = "JWT issuer. If no issuer is specified, kubernetes.io/serviceaccount will be used as the default issuer"
    type        = string
    default     = null
}

variable "pem_keys" {
    description = "List of PEM-formatted public keys or certificates used to verify the signatures of Kubernetes service account JWTs. If a certificate is given, its public key will be extracted."
    type        = list
    default     = null
}

variable "auth_path" {
    description = "The path to mount the auth method. k8s-<cluster_name> by default"
    type        = string
    default     = null
}

variable "sa_namespace" {
    description = "Namespace for auth delegator SA"
    type        = string
    default     = "default"
}