locals {
  istio_repository = "https://istio-release.storage.googleapis.com/charts"
  istio_namespace  = "istio-system"
}

resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = local.istio_repository
  chart            = "base"
  version          = var.istio_chart_version
  namespace        = local.istio_namespace
  create_namespace = true

  atomic  = true
  wait    = true
  timeout = 900

  values = [yamlencode({
    defaultRevision = "default"
  })]
}

resource "helm_release" "istiod" {
  name             = "istiod"
  repository       = local.istio_repository
  chart            = "istiod"
  version          = var.istio_chart_version
  namespace        = local.istio_namespace
  create_namespace = true

  atomic  = true
  wait    = true
  timeout = 900

  depends_on = [helm_release.istio_base]
}