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
pi "# Update first application"
pe 'yq e ".spec.template.spec" ../app-1/deployment-2.yaml'
pe "kubectl diff -f ../app-1/deployment-2.yaml"

pe "kubectl apply -f ../app-1/deployment-2.yaml"

# Check pod
pi "# Get pod information"
pe "kubecolor get pods -l app=chocol-ai-tine -o wide -w"
pe "kubecolor describe pods -l app=chocol-ai-tine"

pi "# End"
# Return to the default PWD
cd ${_PWD}

pe ""