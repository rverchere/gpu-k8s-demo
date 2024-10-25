# Install GPU

```
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia"
helm repo update
helm upgrade --install gpu-operator nvidia/gpu-operator --namespace gpu-operator --create-namespace --wait --version=24.6.2
```

## Strategie MPS

## Strategie MIG Mixed

```
kubectl label nodes gpu-a100-node nvidia.com/mig.config=all-3g.40gb --overwrite=true
```

```yaml
# helm
mig:
  strategy: single
```

```yaml
# deployment
resources:
  limits:
    #nvidia.com/gpu: 1
    nvidia.com/mig-3g.40gb: 1
```