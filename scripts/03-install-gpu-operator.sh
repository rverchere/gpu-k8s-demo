#!/bin/bash
########################
# include the magic
# https://github.com/paxtonhare/demo-magic
########################
. demo-magic.sh
clear

export KUBECONFIG=~/.kube/devoxxfr-gpu-kubeconfig

# Set demo-magic options
DEMO_CMD_COLOR="" # No bold
DEMO_PROMPT="${PURPLE}$ ${COLOR_RESET}"
DEMO_COMMENT_COLOR=$CYAN

# Save original PWD
_PWD=${PWD}

# Install gpu-operator
pi "# Get nvidia gpu-operator chart"
p "helm repo add nvidia https://helm.ngc.nvidia.com/nvidia"
p "helm repo update"

# Install operator
pi "# Install gpu-operator (see specific values later)"
pe "helm upgrade --install gpu-operator nvidia/gpu-operator --namespace gpu-operator --create-namespace --version=24.9.2 -f ../manifests/gpu-operator-values.yaml"

pi "# Check what is installed"
pe "helm  -n gpu-operator list"
pe "kubecolor -n gpu-operator get pods -n gpu-operator"

pi "# End"
# Return to the default PWD
cd ${_PWD}

pe ""