## Terraform file and folder structure

**Module-based architecture with environment layers.**
The core resource definitions live under `modules/` and are reused by per-environment compositions located in `environments/`.
Data blocks for secrets are included directly in each environment.
Ideally I would break it into resources --> modules --> ENV --> components, to avoid code overkill, I used a more simple way, we can discuss it.

```
terraform/
├── README.md
├── STRUCTURE.md                 # this file
│
├── modules/                     # reusable modules
│   ├── resource_group/
│   ├── keyvault/
│   ├── vnets/
│   ├── snets/
│   ├── sql/
│   ├── redis/
│   ├── registry/
│   ├── compute/
│
└── environments/                # environment-specific compositions
    ├── dev/
    │   ├── main.tf              # calls modules with dev values + data blocks
    │   ├── outputs.tf           # environment outputs (Key Vault name, app FQDNs)
    │   ├── variables.tf
    │   ├── backend.tf           # state config for dev
    │   ├── provider.tf          # provider settings for dev
    │   └── terraform.tfvars      # input values for dev
    ├── stage/                   # copy of dev with stage-specific values
    └── prod/                    # production environment
```

**Summary**

| Item | Location |
|------|----------|
| Modules | `modules/` (including keyvault for secret storage) |
| Environments | `environments/<name>/` |
| State | Stored in Azure Storage; each env uses its own key in backend.tf |
| Key Vault | Secrets added as part of the provision block |
| Credentials | Read from Key Vault |

**Deployment workflow**

```bash
# Deploy an environment
cd environments/dev
terraform init
terraform plan
terraform apply
```

Repeat for other environments (stage, prod) by copying the folder and customizing `terraform.tfvars`.
