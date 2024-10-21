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

# Install gpu-operator
pi "# Get nvidia gpu-operator chart"
helm repo remove nvidia &> /dev/null
pe "helm repo add nvidia https://helm.ngc.nvidia.com/nvidia"
p "helm repo update"

# Install operator
pi "# Install gpu-operator"
pe "helm upgrade --install gpu-operator nvidia/gpu-operator --namespace gpu-operator --create-namespace --wait --version=24.6.2"

pi "# Check what is installed"
pe "helm list -n gpu-operator"
pe "kubecolor get pods -n gpu-operator"
pe "kubecolor describe nodes -l nvidia.com/gpu.present=true"

pi "# End"
# Return to the default PWD
cd ${_PWD}

pe ""