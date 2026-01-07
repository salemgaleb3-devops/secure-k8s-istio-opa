# Secure Kubernetes Platform with Istio & OPA (Gatekeeper)

## 📌 Project Overview

This project demonstrates how to design and implement a **secure, production‑oriented Kubernetes platform** using:

* **Istio** for service mesh, mTLS, and fine‑grained authorization
* **OPA Gatekeeper** for policy enforcement at the cluster (platform) level
* **Kubernetes (EKS / kubeadm compatible)** as the orchestration layer

The goal is to apply **Zero Trust Security principles**:

* No implicit trust between services
* All traffic is authenticated and authorized
* Security guardrails are enforced automatically at admission time

This repository is suitable as:

* A **portfolio / CV project for DevOps & Platform Engineers**
* A **reference architecture** for secure Kubernetes environments

---

## 🏗️ Architecture Overview

### Security Layers

1. **Network & Identity Layer (Istio)**

   * mTLS enforced between all workloads
   * Service identity based on SPIFFE

2. **Authorization Layer (Istio AuthorizationPolicy)**

   * Default deny for all services
   * Explicit allow rules for permitted service‑to‑service communication

3. **Ingress Control (Istio Gateway)**

   * Single controlled entry point
   * No direct Service exposure

4. **Policy & Governance Layer (OPA Gatekeeper)**

   * Enforces platform security rules
   * Prevents insecure deployments at admission time

---

## 📂 Repository Structure

```text
secure-k8s-istio-opa
├── debug-pod.yaml                  # Debug pod for connectivity testing
├── helm
│   ├── istio
│   │   └── values.yaml             # Istio Helm custom values
│   └── opa
│       └── values.yaml             # OPA Gatekeeper Helm values
├── istio
│   ├── authorization-policy.yaml   # Zero‑trust authorization rules
│   ├── destination-rule.yaml       # mTLS enforcement
│   ├── gateway.yaml                # Ingress gateway
│   └── peer-authentication.yaml    # STRICT mTLS policy
├── kubernetes-manifests.yaml       # Application manifests (microservices-demo)
├── opa
│   ├── constraints
│   │   └── require-authorizationpolicy.yaml
│   └── templates
│       └── require-authorizationpolicy.yaml
└── scripts
    ├── install-istio.sh
    └── install-opa.sh
```

---

## 🔐 Istio Security Configuration

### 1️⃣ PeerAuthentication (mTLS)

* Enforces **STRICT mTLS** across the `default` namespace
* All workloads must communicate using encrypted and authenticated traffic

```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
spec:
  mtls:
    mode: STRICT
```

---

### 2️⃣ DestinationRule

* Ensures clients use Istio‑managed mutual TLS
* Guarantees identity‑based authorization

```yaml
trafficPolicy:
  tls:
    mode: ISTIO_MUTUAL
```

---

### 3️⃣ AuthorizationPolicy (Zero Trust)

#### Default Deny

All traffic is denied by default:

```yaml
action: DENY
```

#### Explicit Allow

Only specific service‑to‑service calls are allowed (example: frontend → recommendationservice).

This ensures:

* Least privilege
* Clear service communication contracts

---

### 4️⃣ Istio Gateway

* Acts as the **single ingress point**
* Prevents direct exposure of internal services
* Can be extended to HTTPS / TLS termination

---

## 🛡️ OPA Gatekeeper (Policy Enforcement)

### Why OPA?

Istio secures **runtime traffic**, but OPA secures the **platform itself**.

OPA Gatekeeper enforces rules such as:

* "No deployment without AuthorizationPolicy"

---

### ConstraintTemplate

Defines a reusable policy:

> Any Deployment in the `default` namespace **must** have an Istio AuthorizationPolicy.

This prevents accidental insecure deployments.

---

### Constraint

Applies the policy to the cluster:

```yaml
kind: K8sRequireAuthorizationPolicy
```

---

## 🧪 Testing & Validation

### Connectivity Testing

Use the debug pod:

```bash
kubectl exec -it debug-pod -- sh
```

Test service access:

```bash
nc -zv recommendationservice 8080
```

* ❌ Without AuthorizationPolicy → traffic blocked
* ✅ With explicit allow policy → traffic allowed

---

### Admission Control Test (OPA)

Try deploying a workload **without** AuthorizationPolicy:

```bash
kubectl apply -f deployment.yaml
```

Result:

```text
Denied by Gatekeeper: Deployment must have an AuthorizationPolicy
```

---

## 🚀 Installation Steps

### 1️⃣ Install Istio

```bash
./scripts/install-istio.sh
```

### 2️⃣ Install OPA Gatekeeper

```bash
./scripts/install-opa.sh
```

### 3️⃣ Deploy Application

```bash
kubectl apply -f kubernetes-manifests.yaml
```

### 4️⃣ Apply Security Policies

```bash
kubectl apply -f istio/
kubectl apply -f opa/
```

---

## 🎯 Key DevOps Concepts Demonstrated

* Zero Trust Architecture
* Service Mesh Security (mTLS + RBAC)
* Policy as Code (OPA)
* Platform Governance
* Secure Kubernetes Design

---

## 📈 Future Enhancements

* JWT authentication with Istio RequestAuthentication
* HTTPS Gateway with cert‑manager
* Security metrics in Prometheus & Grafana
* CI/CD policy validation
* Multi‑namespace isolation

---

## 👤 Author

**Salem Bamakhram** \
  DevOps Engineer



