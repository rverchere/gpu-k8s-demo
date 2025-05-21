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

# Install app
pi "# Update first application"
pe 'yq e ".spec.template.spec" ../app-1/deployment-2.yaml'
pe "kubectl -n gpu-operator diff -f ../app-1/deployment-2.yaml"

pe "kubectl -n gpu-operator apply -f ../app-1/deployment-2.yaml"

# Check pod
pi "# Get pod information"
pe "kubecolor -n gpu-operator get pods -l app=b-ai-guette -o wide -w"
pe "kubecolor -n gpu-operator describe pods -l app=b-ai-guette"

pi "# End"
# Return to the default PWD
cd ${_PWD}

pe ""
