variable "auth_backend_path" {
  description = "Unique name of the kubernetes backend to configure"
  type        = string
}

variable "role_name" {
  description = "(Required) Name of the role"
  type        = string
}

variable "audience" {
  description = "Audience claim to verify in the JWT"
  type        = string
  default     = ""
}

variable "bound_service_account_names" {
  description = "(Required) List of service account names able to access this role. If set to * all names are allowed"
  type        = list(any)
  default     = []
}

variable "bound_service_account_namespaces" {
  description = "(Required) List of namespaces allowed to access this role. If set to * all namespaces are allowed"
  type        = list(any)
  default     = []
}

variable "alias_name_source" {
  description = "(Optional, default: serviceaccount_uid) Configures how identity aliases are generated"
  type        = string
  default     = ""
}

# Common Token Arguments
variable "token_ttl" {
  description = "Token TTL"
  type        = number
  default     = 3600
}

variable "token_max_ttl" {
  description = "(Optional) The maximum lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time"
  type        = number
  default     = null
}

variable "token_period" {
  description = "(Optional) If set, indicates that the token generated using this role should never expire. The token should be renewed within the duration specified by this value."
  type        = number
  default     = null
}

variable "token_policies" {
  description = "(Optional) List of policies to encode onto generated tokens. Depending on the auth method, this list may be supplemented by user/group/other values."
  type        = list(any)
  default     = []
}

variable "token_bound_cidrs" {
  description = "(Optional) If set, indicates that the token generated using this role should never expire. The token should be renewed within the duration specified by this value."
  type        = list(any)
  default     = null
}

variable "token_explicit_max_ttl" {
  description = "(Optional) If set, will encode an explicit max TTL onto the token in number of seconds. This is a hard cap even if token_ttl and token_max_ttl would otherwise allow a renewal."
  type        = number
  default     = null
}

variable "token_no_default_policy" {
  description = "(Optional) If set, the default policy will not be set on generated tokens; otherwise it will be added to the policies set in token_policies."
  type        = bool
  default     = null
}

variable "token_num_uses" {
  description = "(Optional) The maximum number of times a generated token may be used (within its lifetime); 0 means unlimited"
  type        = number
  default     = null
}

variable "token_type" {
  description = "(Optional) The type of token that should be generated. Can be service, batch, or default to use the mount's tuned default (which unless changed will be service tokens)"
  type        = string
  default     = "default"
}

variable "k8s_policy_rules" {
  description = "Map of k8s policy rules"
  type        = list(any)
}
## Example rules
# k8s_policy_rules = [
#   {
#     path         = "test/path1"
#     capabilities = ["read"]
#   },
#   {
#     path         = "test/path2"
#     capabilities = ["list"]
#   }
# ]