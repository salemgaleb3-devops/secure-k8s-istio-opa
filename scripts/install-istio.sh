#!/bin/bash
set -euo pipefail

ISTIO_VERSION="1.28.2"
ISTIO_NAMESPACE="istio-system"

kubectl get namespace ${ISTIO_NAMESPACE} >/dev/null 2>&1 || kubectl create namespace ${ISTIO_NAMESPACE}

helm repo add istio https://istio-release.storage.googleapis.com/charts

helm install istio-base istio/base \
  --namespace ${ISTIO_NAMESPACE} \
  --version ${ISTIO_VERSION} \
  --wait

helm install istiod istio/istiod \
  --namespace ${ISTIO_NAMESPACE} \
  --version ${ISTIO_VERSION} \
  -f helm/istio/values.yaml \
  --wait

helm install istio-ingress istio/gateway \
  --namespace ${ISTIO_NAMESPACE} \
  --version ${ISTIO_VERSION} \
  --wait

kubectl get pods -n ${ISTIO_NAMESPACE}

