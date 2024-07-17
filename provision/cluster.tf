resource "null_resource" "cluster" {
  provisioner "local-exec" {
    command = "k3d cluster create ${var.k3d_cluster_name} --agents ${var.agent_count} --servers ${var.server_count} --k3s-arg '--disable=traefik@server:0'"
  }
}

# resource "null_resource" "cluster_delete" {
#   provisioner "local-exec" {
#     command = "k3d cluster delete ${var.k3d_cluster_name}"
#     when    = destroy
#   }
# }


resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  namespace        = "argocd-system"
  create_namespace = true

  depends_on = [
    null_resource.cluster
  ]
}

data "external" "env" {
  program = ["${path.module}/env.sh"]
}

resource "kubernetes_secret" "create_git_private_repo_secret" {
  type = "Opaque"
  metadata {
    name      = "argocd-git-secret"
    namespace = helm_release.argocd.namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    "url"      = var.argo-git-repo
    "username" = "not-used"
    "password" = data.external.env.result["gh_token"]
  }

  depends_on = [
    null_resource.cluster
  ]
}

resource "null_resource" "update_argocd_password" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\Updating argocd password...\n"
      kubectl -n ${helm_release.argocd.namespace} patch secret argocd-secret \
        -p '{"stringData": {
          "admin.password": "$2a$12$yiYXJp7v4/KuHhLKuZVV8ejRR/3FF44n/xc5VE33rErNizfrEC/c2",
          "admin.passwordMtime": "'$(date +%FT%T%Z)'"
        }}'
    EOF
  }

  depends_on = [
    kubernetes_secret.create_git_private_repo_secret
  ]
}

resource "null_resource" "create_root_argoapp" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\nCreating root argoapp...\n"
      kubectl --namespace ${helm_release.argocd.namespace} \
        apply -f ./argocd-root-app.yaml
    EOF
  }
}
