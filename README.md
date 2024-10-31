# 0. Préparation

1. Ajouter 1 node GPU
2. Déployer l'appli, et scale à 0

# 1. Deploiement application

## Application sur node GPU

```shell
kubectl apply --namespace gpu-operator -f app-1/deployment-1.yaml
```

Open https://chocol-ai-tine.devfest-toulouse.opsrel.io/

## Application sur node GPU, avec resources
```shell
kubectl apply --namespace gpu-operator -f app-1/deployment-2.yaml
```

# 2. Install GPU Operator

## Installation chart Helm

```shell
# helm repo add nvidia https://helm.ngc.nvidia.com/nvidia
# helm repo update
helm upgrade --install gpu-operator nvidia/gpu-operator --namespace gpu-operator --create-namespace --wait --version=24.6.2 -f manifests/gpu-operator-values.yaml
```

## Vérification appli

## Installation 2eme appli

```shell
kubectl apply --namespace gpu-operator -f app-2/deployment-2.yaml
```

# 3. GPU Sharing -  Strategie MIG

## Strategie MIG Mixed

```yaml
# helm
mig:
  strategy: mixed
```

Scale des déploiements à 0 pour permettre la reconfiguration du driver

```
kubectl scale deployment pech-ai-bou --replicas 0
kubectl scale deployment chocol-ai-tine --replicas 0
```

```shell
kubectl label node -l "node.k8s.ovh/type=gpu" "nvidia.com/mig.config=all-3g.40gb" --overwrite
```

```yaml
# deployment
resources:
  limits:
    #nvidia.com/gpu: 1
    nvidia.com/mig-3g.40gb: 1
```

```shell
kubectl apply --namespace gpu-operator -f app-1/deployment-3.yaml
kubectl apply --namespace gpu-operator -f app-2/deployment-3.yaml
```


# 4. GPU Sharing -  Strategie MPS

```yaml
# helm
devicePlugin:
  config:
    create: true
    default: "mps4"
    name: "mps-parted-config"
    data:
      mps4: |-
        version: v1
        sharing:
          mps:
            resources:
            - name: nvidia.com/gpu
              replicas: 4
```

