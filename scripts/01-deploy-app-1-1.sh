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
pi "# Install first application"
pe  "bat ../app-1/app.py"
pe 'yq e ".spec.template.spec" ../app-1/deployment-1.yaml'
pe "kubecolor apply -f ../app-1/deployment-1.yaml"

# Check pod
pi "# Get pod information"
pe "kubecolor get pods -l app=chocol-ai-tine -o wide -w"
pe "kubecolor describe pods -l app=chocol-ai-tine"

pe "# Go to https://chocol-ai-tine.devfest-toulouse.opsrel.io/ and Generate some images"
open https://chocol-ai-tine.devfest-toulouse.opsrel.io/

pe "kubectl logs $(kubectl get pod -l app=chocol-ai-tine -o name)"

pi "# Check GPU node"
pe 'kubecolor get node -l "node.k8s.ovh/type=gpu"'
pe 'kubecolor describe node -l "node.k8s.ovh/type=gpu"'

pi "# End"
# Return to the default PWD
cd ${_PWD}

pe ""