output "cluster_name" { value = var.cluster_name }
output "argocd_namespace" { value = helm_release.argocd.namespace }
output "argocd_release_name" { value = helm_release.argocd.name }
output "port_forward_command" {
  value = "kubectl -n ${var.namespace} port-forward svc/argocd-server 8080:443"
}