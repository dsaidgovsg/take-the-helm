# Take the Helm

Helm workshop

## Setup

1. Install [`minikube`](https://minikube.sigs.k8s.io/docs/start/)
2. Install [`helm`](https://helm.sh/docs/intro/install/)
3. Install [`docker`](https://docs.docker.com/get-docker/)

## Steps

1. Start cluster
```bash
minikube start
```
2. Check if cluster is ready
```bash
kubectl get po -A
```
3. Install helm chart
```bash
helm install app charts/take-the-helm -n custom --create-namespace --dry-run
helm install app charts/take-the-helm -n custom --create-namespace
```
4. Uninstall helm chart
```bash
helm uninstall app -n custom
```

## Useful Commands

#### Debugging

```
helm lint charts/take-the-helm
helm template app charts/take-the-helm
```
