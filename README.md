# EuroRoute-IO: Sovereign Green Logistics Optimizer
**EuroRoute-IO** is an API-first demonstration project that optimizes freight logistics across Europe. It calculates routes based on cost, weather risk, and carbon footprint while ensuring that sensitive business data remains entirely within **EU-owned infrastructure**, shielded from non-EU government access.

---

### 1. Architecture: The Hybrid Sovereign Stack
This stack uses **AWS** for high-performance, stateless execution and **PolyAPI** as the orchestration backbone. All sensitive data and secret management are offloaded to **EU-sovereign** providers to ensure 100% GDPR compliance and immunity from the US CLOUD Act.

| Component | Service | Role | EU Sovereign Alternative (Data) |
| :--- | :--- | :--- | :--- |
| **Secrets** | **OVHcloud KMS** | **Hardware-backed Key Management** | **Managed KMS (France)** |
| **Orchestrator** | **PolyAPI** | Unified SDK for all 3rd-party APIs | **Self-hosted Poly Runner** (on Hetzner) |
| **Compute** | **AWS Lambda** | Stateless business logic (EU regions) | *N/A (Stateless)* |
| **Gateway** | **AWS API Gateway** | Entry point for client requests | *N/A (Stateless)* |
| **Database** | **Aiven / PostgreSQL** | Persistent storage of shipment data | **Hetzner Managed DB** (Germany) |
| **Cache** | **UpCloud / Redis** | Real-time tracking & session data | **Exoscale DBaaS** (Switzerland/Austria) |
| **Storage** | **Scaleway S3** | Documentation, logs, and blobs | **OVHcloud Object Storage** (France) |

---

### 2. Workflow: The Sovereign Orchestration Flow
The following flow describes how **OVHcloud KMS** secures the integration while PolyAPI simplifies the execution.

1.  **Request:** A user sends a shipment request to the **AWS API Gateway**.
2.  **Secret Retrieval:** **AWS Lambda** authenticates with **OVHcloud KMS** (France) to retrieve the encrypted API keys for the logistics providers.
3.  **Orchestration (PolyAPI Layer):** Lambda passes the credentials into the **PolyAPI Unified SDK**. PolyAPI then concurrently pings:
    * **Logistics APIs:** DHL/FedEx for real-time pricing.
    * **Carbon APIs:** Climatiq for $CO_2$ impact.
    * **Weather APIs:** OpenWeather for transit risks.
    * **Maps APIs:** Mapbox for distance/ETAs.
4.  **Transformation:** PolyAPI maps these different data formats into a single, unified **Project Schema**.
5.  **Sovereign Storage:** The Lambda takes the final payload and stores it in **Aiven (EU)**.
6.  **Response:** The user receives a finalized, eco-optimized shipping route.

---

### 3. Data Sovereignty Implementation Details
To remain immune to the US CLOUD Act and fully GDPR compliant, the project implements these specific guardrails:

* **Jurisdictional Isolation:** We use AWS purely for **processing** (in `eu-central-1`). All "State" (databases, caches, and logs) is managed by EU-headquartered companies.
* **Sovereign Key Management:** Instead of AWS Secrets Manager or Vaults with US parents, we use **OVHcloud KMS**. This ensures the cryptographic keys used to access shipping APIs are never stored or processed by a US entity.
* **The "Runner" Strategy:** We deploy a **PolyAPI Runner** on a German **Hetzner** instance. This ensures the actual data transit from the external APIs happens on EU-owned "metal" before the result is passed to the stateless Lambda.

---

### 4. Scaling Options for the Future
This project is designed to scale horizontally and vertically:

* **API Expansion:** Easily add **Stripe** for payments or **SendGrid** for notifications by simply "cataloging" them in PolyAPI. No need to install new libraries in your Lambda.
* **Geographic Expansion:** Deploy your database in different EU countries (e.g., **Aiven** in France or Italy) to comply with specific local data residency laws.
* **Machine Learning:** Use the shipment data stored in your EU database to build an "Arrival Predictor" using **OVHcloud’s AI training platform**.
* **IoT Integration:** Scale into "Real-time Tracking" by integrating **MQTT/IoT APIs** via PolyAPI webhooks to monitor temperature-sensitive cargo.

---

> **Project Vision:** "Move goods across borders without moving data across jurisdictions."