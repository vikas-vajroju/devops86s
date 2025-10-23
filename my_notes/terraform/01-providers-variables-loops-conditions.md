# 🌍 Terraform Deep Dive — Providers, Variables, Loops & Conditions

Welcome to a beginner-friendly deep dive into **Terraform fundamentals** that every DevOps engineer must master.  
These are **core building blocks** you’ll use in almost every infrastructure-as-code (IaC) project.

---

## 🧠 1. Providers — The Brains Behind Terraform

### 🔹 What Are Providers?
Providers are plugins that tell Terraform **which platform or service** to interact with — like Azure, AWS, GCP, GitHub, Kubernetes, etc.

Every resource in Terraform belongs to a provider. Without defining a provider, Terraform wouldn’t know where to create or manage resources.

Think of providers as **Terraform’s translators** — they convert your `.tf` code into actual cloud API calls.

### 🔹 Common Providers
- `azurerm` → Azure
- `aws` → Amazon Web Services
- `google` → Google Cloud Platform
- `kubernetes` → For managing K8s clusters
- `github` → For managing GitHub repositories

### 🔹 Example — Azure Provider Setup
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

**Explanation:**
- `required_providers` → tells Terraform which provider plugin to use and from where.
- `source` → defines the namespace (in this case, HashiCorp official).
- `version` → keeps your provider version consistent across machines.
- `features {}` → a required block for AzureRM, even if empty.

### ✅ Commands to Run
```bash
terraform init    # Downloads provider plugin
terraform plan    # Previews the infrastructure changes
terraform apply   # Creates the infrastructure
```

---

## 🧩 2. Variables — Reusable Configuration Values

### 🔹 Why Use Variables?
Hardcoding values like region or resource names isn’t scalable.  
Variables make your Terraform configuration **reusable, flexible, and cleaner**.

### 🔹 Defining Variables
```hcl
variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
    project     = "demo-app"
  }
}
```

### 🔹 Using Variables
```hcl
resource "azurerm_resource_group" "example" {
  name     = "rg-demo"
  location = var.location
  tags     = var.tags
}
```

### 🔹 Providing Variable Values
1. **Default value:** defined in variable block  
2. **Command-line:**  
   ```bash
   terraform apply -var="location=Central India"
   ```
3. **Terraform variable file:** `terraform.tfvars`
   ```hcl
   location = "West Europe"
   ```
4. **Environment variables:**
   ```bash
   export TF_VAR_location="South India"
   ```

---

## 🔁 3. Loops — Creating Multiple Resources Dynamically

Loops help us **avoid code repetition** by creating multiple similar resources automatically.

Terraform supports two types of looping:
- `count`
- `for_each`

### 🧮 Example 1 — Using Count
```hcl
resource "azurerm_resource_group" "rg" {
  count    = 3
  name     = "rg-${count.index}"
  location = "East US"
}
```
🧾 **Result:**  
Creates 3 resource groups → `rg-0`, `rg-1`, `rg-2`

### 🧩 Example 2 — Using for_each with List or Map
```hcl
variable "regions" {
  default = ["eastus", "westeurope"]
}

resource "azurerm_resource_group" "multi" {
  for_each = toset(var.regions)
  name     = "rg-${each.key}"
  location = each.value
}
```
🧾 **Result:**  
Creates a resource group in both regions.

### 🔸 Example 3 — Using for_each with a Map
```hcl
variable "projects" {
  default = {
    dev  = "East US"
    prod = "West Europe"
  }
}

resource "azurerm_resource_group" "env_rg" {
  for_each = var.projects
  name     = "rg-${each.key}"
  location = each.value
}
```
🧾 **Result:**
- `rg-dev` in East US  
- `rg-prod` in West Europe

### 🔍 When to Use Which
| Use Case | Recommended |
|-----------|--------------|
| You just need N copies | `count` |
| You want unique identifiers (keys) | `for_each` |

---

## ⚙️ 4. Conditions — Adding Logic to Terraform

Sometimes we need **decision-making** in Terraform (e.g., different resource sizes for prod vs dev).  
Terraform supports **ternary operator syntax** for conditional logic:

```hcl
condition ? true_value : false_value
```

### 💡 Example — Conditional Resource Naming
```hcl
variable "env" {
  default = "dev"
}

resource "azurerm_resource_group" "example" {
  name     = var.env == "prod" ? "rg-prod" : "rg-dev"
  location = "East US"
}
```

🧾 **Result:**
- If `env = prod` → resource group name = `rg-prod`
- If `env = dev` → resource group name = `rg-dev`

### 💡 Example — Conditional VM Size
```hcl
variable "is_production" {
  default = false
}

variable "vm_size" {
  default = var.is_production ? "Standard_D4s_v3" : "Standard_B2s"
}
```

🧾 **Result:**
- For production → larger VM
- For development → smaller, cheaper VM

### 💡 Example — Conditional Resource Creation (with count)
```hcl
variable "create_rg" {
  default = true
}

resource "azurerm_resource_group" "optional" {
  count    = var.create_rg ? 1 : 0
  name     = "rg-optional"
  location = "East US"
}
```
🧾 **Result:**
- Resource group created only if `create_rg = true`

---

## 🧾 Summary Table

| Concept | Purpose | Syntax Example | Key Benefit |
|----------|----------|----------------|--------------|
| **Provider** | Connect Terraform to a platform | `provider "azurerm" {}` | Enables resource creation |
| **Variable** | Reusable config value | `var.location` | Flexibility & reuse |
| **Loop (count)** | Repeat same resource N times | `count = 3` | Automates repetition |
| **Loop (for_each)** | Create resources with unique keys | `for_each = var.map` | Data-driven infra |
| **Condition** | Add logic (if-else) | `condition ? true : false` | Environment-specific configs |

---

## 🧠 Pro Tips for Terraform Learners
- ✅ Always run `terraform fmt` → formats code.
- ✅ Run `terraform validate` → checks syntax.
- ✅ Run `terraform plan` → preview changes before applying.
- 💾 Use `.tfvars` files for environment-specific settings.
- 🧱 Keep providers version-locked for consistent environments.

---

## 📘 Next Topic Preview → Terraform State, Remote Backends & Locking 🔐

We’ll cover how Terraform tracks resources, manages state files, and uses remote backends securely.

---
