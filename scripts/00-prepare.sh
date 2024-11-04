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

# Scale to 0 apps
pei "kubectl scale deployment pech-ai-bou --replicas 0"
pei "kubectl scale deployment chocol-ai-tine --replicas 0"


# Remove gpu-operator
pi "# Remove nvidia gpu-operator chart"
pei "helm uninstall gpu-operator -n gpu-operator"

# Prepare apps
pei "kubectl apply -f ../app-1/deployment-0.yaml"
pei "kubectl apply -f ../app-1/deployment-1.yaml"
pe "kubecolor -n gpu-operator get pods -w"
pei "kubectl -n gpu-operator scale deploy chocol-ai-tine --replicas 0"

pei "kubectl apply -f ../app-2/deployment-0.yaml"
pei "kubectl apply -f ../app-2/deployment-1.yaml"
pe "kubecolor -n gpu-operator get pods -w"
pei "kubectl -n gpu-operator scale deploy pech-ai-bou --replicas 0"

pi "# End"
# Return to the default PWD
cd ${_PWD}

pe ""