resource "helm_release" "argocd" {
  depends_on       = [minikube_cluster.minikube_docker] # wait for cluster
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  # Make Helm actually wait long enough
  wait    = true
  timeout = 900  # 15 minutes
  atomic  = true # rollback on failure (keeps cluster clean)

  values = [<<-YAML
    crds:
      install: true      # ensure CRDs are installed by the chart
    server:
      service:
        type: ClusterIP
  YAML
  ]
}
