# Terraform infrastructure for RXNT Hello World

This folder contains a **modular, component-based** Terraform configuration to satisfy the assignment requirements:

- Provision Azure infrastructure using Terraform
- Deploy the `Site` and `Api` containers in a production‑like architecture
- Cache data in Redis and pull current date from Azure SQL

## Architecture overview

The infrastructure is organized as described below:

1. **Resource Group** – deployment boundary
2. **Virtual Network (VNet)** – network isolation
3. **Subnets + NSGs** – Container Apps subnet, private endpoints subnet
4. **Azure SQL Server & Database** – holds the sensitive date data, private endpoint only
5. **Azure Cache for Redis** – private endpoint only
6. **Azure Container Registry (ACR)** – api & site images here
7. **Container Apps Environment + Apps** – Site (public) and API (internal) with autoscaling

## The code was built while assuming the next:
1. Secrets are created as part of the TF code, not the best practice, but for the assignment purposes I used it inside the code
2. A dedicated service principal exists with defined permissions for terraform
3. Firewall rules exist (if needed, in my case access is via private endpoints)
4. NSGs are default to allow public outbount and access via loadbalancer
5. ACR uses a different RG that already exists
6. Images uploaded using provision block, in real scenario I would it as a separate CI/CD pipeline
7. Redis & SQL might be also a bottleneck, no data for the expected number of connections (current SKU for SQL is S0, limits to 600 connections).
a better approach I can recommend is maybe to use elastic pool.

Each environment in `environments/` composes reusable modules from `modules/`. Sensitive data is fetched directly from Key Vault using data blocks in the environment.

## Getting started

### Environment variables expected by the containers

Before deploying compute, remember the app requirements from the original assignment:

* **Site container** needs:
  * `REDIS_CONNECTION_STRING` – connection string for Redis (provided by the redis component output)
  * `MarketingApi__BaseUrl` – base URL of the API (computed from the API container app FQDN)
* **API container** needs:
  * `DB_CONNECTION_STRING` – SQL Server connection string (constructed using the SQL component output and password from Key Vault)

My `compute` component wires those values automatically using the Terraform outputs and variables.

### 1. Prerequisites

- Azure subscription with permissions to create resources
- Azure service principal (app registration with client ID and secret)
- **Backend resource group** `rg-terraform-state` created manually (contains storage account for Terraform state)
- Terraform >= 4.1.0 (used new provider version for azure)

### 2. Configure service principal credentials

Before deploying, set the service principal credentials as environment variables:

```bash
export ARM_CLIENT_ID="<your-service-principal-client-id>"
export ARM_CLIENT_SECRET="<your-service-principal-client-secret>"
export TF_VAR_client_id="$ARM_CLIENT_ID"
export TF_VAR_client_secret="$ARM_CLIENT_SECRET"
```

The provider will use these credentials along with `subscription_id` and `tenant_id` to authenticate with Azure.

### 3. Deploy using an environment

Rather than running each piece individually, you can deploy a complete environment which composes all modules. An example environment exists under `environments/dev` (copy the folder for additional environments such as `stage` or `prod`).

```bash
cd environments/dev
# Edit terraform.tfvars with appropriate subscription_id, tenant_id, names, CIDRs, and Key Vault details
terraform init
terraform plan
terraform apply
```

After deployment, get important outputs:

```bash
terraform output key_vault_name
terraform output site_app_fqdn
```

The environment `main.tf` invokes each module in order and wires outputs between them, so a single `terraform apply` builds the full stack (resource group, network, SQL, Redis, ACR, Key Vault, compute, etc.). Sensitive data like SQL credentials are fetched directly from Key Vault using data blocks.


## Load Balancing

The infrastructure includes **automatic load balancing** via Azure Container Apps:

- **Site App**: Exposed externally with `external_enabled = true`, automatically gets a public IP and load balancer
- **API App**: Internal only (`external_enabled = false`), accessed only by Site app over private network
- **Autoscaling**: Both apps auto-scale based on traffic (min/max replicas configurable)
- **Traffic Distribution**: Container Apps platform automatically distributes traffic across healthy replicas

## Scaling considerations for future

- Upgrade Redis from **Basic** to **Standard Cluster** for higher throughput
- Upgrade SQL from **S0** to **S3+** for higher concurrent connections
- Add **Application Gateway** or **Azure Front Door** for multi-region, WAF, DDoS protection
- Implement **Azure Policy** for governance and compliance
- Add **Virtual Network peering** or **VPN** for hybrid/multi-cloud deployment
- Consider **Azure Kubernetes Service (AKS)** for more complex workloads

## Folder structure

See [STRUCTURE.md](./STRUCTURE.md) for detailed folder layout and state management strategy.

