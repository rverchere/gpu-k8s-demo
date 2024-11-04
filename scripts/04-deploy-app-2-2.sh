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

# Install app
pi "# Install second application"
pe 'yq e ".spec.template.spec" ../app-2/deployment-2.yaml'
pe "kubectl apply -f ../app-2/deployment-2.yaml"

# Check pod
pi "# Get pod information"
pe "kubecolor get pods -l app=pech-ai-bou -o wide -w"
pe "kubecolor describe pods -l app=pech-ai-bou"

pe 'kubecolor describe node -l "node.k8s.ovh/type=gpu"'

pi "# End"
# Return to the default PWD
cd ${_PWD}

pe ""