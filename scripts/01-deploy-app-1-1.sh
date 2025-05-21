#!/bin/bash
########################
# include the magic
# https://github.com/paxtonhare/demo-magic
########################
. demo-magic.sh
clear

export KUBECONFIG=~/.kube/devoxxfr-gpu-kubeconfig

# Set demo-magic options
TYPE_SPEED=50 # Accelerate typing
DEMO_CMD_COLOR="" # No bold
DEMO_PROMPT="${PURPLE}$ ${COLOR_RESET}"
DEMO_COMMENT_COLOR=$CYAN

# Save original PWD
_PWD=${PWD}

# Install app
pi "# Install first application"
pe "bat ../app-1/app.py"
pe 'yq e ".spec.template.spec" ../app-1/deployment-1.yaml'
pe "kubecolor -n gpu-operator apply -f ../app-1/deployment-1.yaml"

# Check pod
pi "# Get pod information"
pe "kubecolor -n gpu-operator get pods -l app=b-ai-guette -o wide -w"
#pe "kubecolor -n gpu-operator describe pods -l app=b-ai-guette"

pe "# Go to https://b-ai-guette.cloud-native-aix-mrs.opsrel.io/ and Generate some images"
open https://b-ai-guette.cloud-native-aix-mrs.opsrel.io/

pe "kubectl -n gpu-operator logs $(kubectl -n gpu-operator get pod -l app=b-ai-guette -o name)"

pi "# Check GPU node"
pe 'kubecolor -n gpu-operator get node -l "node.k8s.ovh/type=gpu" --show-labels'
#pe 'kubecolor -n gpu-operator describe node -l "node.k8s.ovh/type=gpu"'

pi "# End"
# Return to the default PWD
cd ${_PWD}

pe ""
