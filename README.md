# 💰 KubeWealth: Polyglot Microservices on K8s

A production-ready finance microservices project demonstrating interoperability between Go, Python, and Java within a Kubernetes ecosystem.

---

## 🏗️ Architecture

* **Transaction Service (Go 1.26)**: High-performance ledger operations
* **Balance Service (Python 3.9)**: FastAPI-based account management
* **Identity Service (Java 17)**: Spring Boot authentication layer

---

## 🛠️ Local Build & Test

### 1. Build Individual Images

From the root directory, build each service manually to verify the Dockerfiles:

```bash
# Build Transaction (Go)
podman build -t kubewealth-go ./go

# Build Balance (Python)
podman build -t kubewealth-python ./python

# Build Identity (Java)
podman build -t kubewealth-java ./java
```

---

### 2. Run the Stack

Use Podman Compose to spin up the entire networked environment:

```bash
# Dry Run
podman compose -f podman-compose.yml up --dry-run

# Build images before starting containers
podman compose -f podman-compose.yml up --build
```

---

### 3. Verification (Testing with Curl)

Open a terminal and run these commands to ensure each microservice is healthy:

| Service | Command                                       | Expected Output                            |
| ------- | --------------------------------------------- | ------------------------------------------ |
| Go      | `curl -X POST http://localhost:8080/transfer` | Transaction Successful (Go Service)        |
| Python  | `curl http://localhost:8000/balance/atharv`   | `{"user_id":"atharv","balance":1000.0...}` |
| Java    | `curl http://localhost:8081/auth`             | User Authenticated (Java 17 Service)       |

---
