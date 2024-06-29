variable "k3d_cluster_name" {
  default = "homelab"
  type    = string
}

variable "server_count" {
  default = 1
  type    = number
}

variable "agent_count" {
  default = 3
  type    = number
}

variable "argo-git-repo" {
  default = "https://github.com/nicolastakashi/homelab"
  type = string
}