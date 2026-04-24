# EuroRoute-IO: Sovereign Green Logistics Optimizer
**EuroRoute-IO** is an API-first demonstration project that optimizes freight logistics across Europe. It calculates routes based on cost, weather risk, and carbon footprint while ensuring that sensitive business data remains entirely within **EU-owned infrastructure**, shielded from non-EU government access.

---

### 1. Architecture: The Hybrid Sovereign Stack
This stack uses **AWS** for high-performance, stateless execution and **PolyAPI** as the orchestration backbone, while offloading all data storage to **EU-sovereign** providers to ensure 100% GDPR data residency.

| Component | Service | Role | EU Sovereign Alternative (Data) |
| :--- | :--- | :--- | :--- |
| **Orchestrator** | **PolyAPI** | Unified SDK for all 3rd-party APIs | **Self-hosted Poly Runner** (on Hetzner) |
| **Compute** | **AWS Lambda** | Stateless business logic (EU regions) | *N/A (Stateless)* |
| **Gateway** | **AWS API Gateway** | Entry point for client requests | *N/A (Stateless)* |
| **Database** | **Aiven / PostgreSQL** | Persistent storage of shipment data | **Hetzner Managed DB** (Germany) |
| **Cache** | **UpCloud / Redis** | Real-time tracking & session data | **Exoscale DBaaS** (Switzerland/Austria) |
| **Storage** | **Scaleway S3** | Documentation, logs, and blobs | **OVHcloud Object Storage** (France) |


---

### 2. Workflow: The PolyAPI Orchestration Flow
The following schema describes how PolyAPI simplifies the "multi-API" mess into a single, secure stream.

1.  **Request:** A user sends a shipment request (Origin/Destination) to the **AWS API Gateway**.
2.  **Trigger:** **AWS Lambda** activates and calls the **PolyAPI Unified SDK**.
3.  **Orchestration (PolyAPI Layer):** PolyAPI handles the heavy lifting by calling:
    * **Logistics APIs:** DHL/FedEx for real-time pricing.
    * **Carbon APIs:** Climatiq for $CO_2$ impact.
    * **Weather APIs:** OpenWeather for transit risks.
    * **Maps APIs:** Mapbox for distance/ETAs.
4.  **Transformation:** PolyAPI maps these different data formats into a single **Project Schema**.
5.  **Sovereign Storage:** The Lambda takes the clean payload and stores it in **Aiven (EU)**.
6.  **Response:** The user receives a finalized, eco-optimized shipping route.

graph TD
    %% User Entry
    User((User/Client)) -->|1. Request Route| AGW[AWS API Gateway]

    %% AWS Stateless Layer
    subgraph AWS_Cloud ["AWS Cloud (Stateless / EU-Region)"]
        AGW -->|2. Trigger| Lambda[AWS Lambda]
        Lambda -->|3. Invoke Unified SDK| PolyRunner
    end

    %% PolyAPI Orchestration Layer
    subgraph PolyAPI_Layer ["PolyAPI Orchestration Layer"]
        PolyRunner[PolyAPI Runner]
        
        %% Concurrent API Calls
        PolyRunner -->|4a. Price/Time| DHL[DHL Express API]
        PolyRunner -->|4b. CO2 Impact| Climatiq[Climatiq API]
        PolyRunner -->|4c. Risk| Weather[OpenWeather API]
        PolyRunner -->|4d. Distance| Mapbox[Mapbox API]
    end

    %% EU Sovereign Data Boundary
    subgraph EU_Sovereign_Zone ["EU Sovereign Infrastructure (Data Storage)"]
        direction TB
        DB[(Aiven PostgreSQL)]
        Cache[(UpCloud Redis)]
        S3[(Scaleway S3)]
        
        %% Data Flow to Storage
        Lambda -.->|5. Secure Save| DB
        Lambda -.->|5. Session Cache| Cache
        Lambda -.->|5. Logs/Blobs| S3
    end

    %% Final Response
    DB -.->|6. Confirmation| Lambda
    Lambda -->|7. Optimized JSON| User

    %% Styling
    style EU_Sovereign_Zone fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    style PolyAPI_Layer fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    style AWS_Cloud fill:#fff3e0,stroke:#e65100,stroke-width:2px

---

### 3. Data Sovereignty Implementation Details
To remain immune to the US CLOUD Act and fully GDPR compliant, the project implements these specific guardrails:

* **Jurisdictional Isolation:** We use AWS purely for **processing** (in `eu-central-1`). We never use AWS storage services (RDS, DynamoDB, S3) which are subject to US parent company control.
* **PolyAPI Vault:** Instead of AWS Secrets Manager, we use the **PolyAPI Vault** (or a self-hosted HashiCorp Vault on Scaleway) to manage API keys, keeping them outside the US ecosystem.
* **The "Runner" Strategy:** We deploy a **PolyAPI Runner** on a German **Hetzner** instance. This ensures the actual data transit from the external APIs happens on EU-owned metal before the result is passed to the Lambda.

---

### 4. Scaling Options for the Future
This project is designed to scale horizontally and vertically:

* **API Expansion:** Easily add **Stripe** for payments or **SendGrid** for notifications by simply "cataloging" them in PolyAPI. No need to install new libraries in your Lambda.
* **Geographic Expansion:** Deploy your database in different EU countries (e.g., **Aiven** in France or Italy) to comply with specific local data residency laws.
* **Machine Learning:** Use the shipment data stored in your EU database to build an "Arrival Predictor" using **OVHcloud’s AI training platform**.
* **IoT Integration:** Scale into "Real-time Tracking" by integrating **MQTT/IoT APIs** via PolyAPI webhooks to monitor temperature-sensitive cargo.

---

> **Project Vision:** "Move goods across borders without moving data across jurisdictions."