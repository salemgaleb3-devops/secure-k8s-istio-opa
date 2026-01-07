#!/bin/bash
set -euo pipefail

OPA_NAMESPACE="opa-system"

kubectl get namespace ${OPA_NAMESPACE} >/dev/null 2>&1 || kubectl create namespace ${OPA_NAMESPACE}

helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm repo update

helm install gatekeeper gatekeeper/gatekeeper \
  --namespace ${OPA_NAMESPACE} \
  -f helm/opa/values.yaml \
  --wait \

kubectl get pods -n ${OPA_NAMESPACE}

