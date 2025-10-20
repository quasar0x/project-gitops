# Project GitOps with Terraform, Minikube & ArgoCD

This project bootstraps a local Kubernetes cluster using Minikube and provisions ArgoCD via Helm. It also deploys a Python Flask app using Helm and manages everything through GitOps.

---

## Project Structure

```bash
project-gitops/
├── .github/workflows/        # GitHub Actions workflow
│   └── gitops.yml            # CI/CD: Docker image build + Helm chart update
├── helm-python-app/          # Helm chart for Python Flask app
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── deployment.yaml
│       └── service.yaml
├── argocd-app.yaml           # ArgoCD Application manifest
├── app.py                    # Minimal Flask app
├── Dockerfile                # Dockerfile for the app
└── terraform-config/         # Infrastructure-as-code
    ├── main.tf
    ├── provider.tf
    ├── argocd.tf
    ├── variables.tf
```

---

## Prerequisites

- Terraform ≥ 1.3
- Minikube + Docker
- Helm
- kubectl
- ArgoCD CLI (`brew install argocd`)
- GitHub PAT (for repo push via CI)

---

## Setup Workflow

1. **Terraform** provisions:
   - Minikube cluster
   - ArgoCD via Helm in `argocd` namespace

2. **ArgoCD** watches the Git repo for Helm chart updates

3. **GitHub Actions** automates image build, tagging, and GitOps sync

---

## Usage

### 1. Initialize Terraform
```bash
cd terraform-config
terraform init
```

### 2. Apply Infrastructure
```bash
terraform apply
```

### 3. Port Forward ArgoCD UI
```bash
kubectl port-forward svc/argocd-server -n argocd 8081:443
```
Then visit: [https://localhost:8081](https://localhost:8081)

### 4. Retrieve ArgoCD Admin Password
```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

### 5. Login to ArgoCD CLI
```bash
argocd login localhost:8081 --username admin --password <pwd> --insecure
```

---

## Python App Access

### Port Forward Service
```bash
kubectl port-forward service/project-gitops-helm-python-app 8082:8080 -n default
```
Then visit: [http://localhost:8082](http://localhost:8082)

You should see the current time returned from the Flask app.
---

## Cleanup
```bash
terraform destroy
```
OR
```bash
minikube delete
```

