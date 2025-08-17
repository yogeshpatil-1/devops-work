# GitOps Repo for Argo CD - App of Apps (GKE)

This repository demonstrates the **App of Apps** pattern on Argo CD running in a GKE cluster.
It includes:
- A parent `Application` that references the `apps/` folder (recursive).
- Three child apps (dev, staging, prod) using Kustomize with different replica counts.
- A Helm-based child app using a local chart (`charts/hello-helm`).

## Structure

```
gitops-repo/
 ├── apps/
 │    ├── app-of-apps.yaml
 │    ├── dev.yaml
 │    ├── staging.yaml
 │    ├── prod.yaml
 │    └── hello-helm.yaml
 ├── dev/
 │    ├── kustomization.yaml
 │    ├── deployment.yaml
 │    └── service.yaml
 ├── staging/
 │    ├── kustomization.yaml
 │    ├── deployment.yaml
 │    └── service.yaml
 ├── prod/
 │    ├── kustomization.yaml
 │    ├── deployment.yaml
 │    └── service.yaml
 └── charts/
      └── hello-helm/
           ├── Chart.yaml
           ├── values.yaml
           └── templates/
               ├── deployment.yaml
               └── service.yaml
```

## Bootstrap

1. Push this repo to your Git provider (GitHub/GitLab).
2. Apply ONLY the parent app into the `argocd` namespace:

```bash
kubectl apply -n argocd -f apps/app-of-apps.yaml
```

Argo CD will then discover and sync all child apps automatically.

> Tip: The child Applications use `syncOptions: ["CreateNamespace=true"]` so the destination namespaces are created for you.