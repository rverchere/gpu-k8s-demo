# Install GPU

```
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia"
helm repo update
helm upgrade --install gpu-operator nvidia/gpu-operator --namespace gpu-operator --create-namespace --wait --version=24.6.2
```

## Strategie MPS

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

## Strategie MIG Mixed


```yaml
# helm
mig:
  strategy: mixed # or single
```

```shell
kubectl label nodes gpu-a100-node nvidia.com/mig.config=all-3g.40gb --overwrite=true
```

```yaml
# deployment
resources:
  limits:
    #nvidia.com/gpu: 1
    nvidia.com/mig-3g.40gb: 1
```