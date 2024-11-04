#!/bin/bash
########################
# include the magic
# https://github.com/paxtonhare/demo-magic
########################
. demo-magic.sh
clear

export KUBECONFIG=~/.kube/devfest-gpu-kubeconfig

# Set demo-magic options
TYPE_SPEED=50 # Accelerate typing
DEMO_CMD_COLOR="" # No bold
DEMO_PROMPT="${PURPLE}$ ${COLOR_RESET}"
DEMO_COMMENT_COLOR=$CYAN

# Save original PWD
_PWD=${PWD}

# Activate GPU Sharing
pi "# Check operator configuration"
pe "bat -r 0:3 ../manifests/gpu-operator-values.yaml"

p "# Scale deployment to 0"
pe "kubectl scale deployment pech-ai-bou --replicas 0"
pe "kubectl scale deployment chocol-ai-tine --replicas 0"

p "# Label node"
pe 'kubectl label node -l "node.k8s.ovh/type=gpu" "nvidia.com/mig.config=all-3g.40gb" --overwrite'

p "# Get pods status, and check with k9s"
pe 'kubecolor get pods -w'
pe 'kubecolor describe node -l "node.k8s.ovh/type=gpu"'

p "# Apply new deployment configuration"
pe "kubectl diff -n gpu-operator -f ../app-1/deployment-3.yaml"
pe "kubectl apply -n gpu-operator -f ../app-1/deployment-3.yaml"
pe "kubectl diff -n gpu-operator -f ../app-2/deployment-3.yaml"
pe "kubectl apply -n gpu-operator -f ../app-2/deployment-3.yaml"

p "# Open application and generate image"

p "# Check nvidia-smi"
pe "kubectl exec $(kubectl get pod -l app.kubernetes.io/component=nvidia-driver -o name) -- nvidia-smi"

pi "# End"
# Return to the default PWD
cd ${_PWD}

pe ""