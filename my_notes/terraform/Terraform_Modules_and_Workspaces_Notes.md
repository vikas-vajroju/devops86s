# Terraform Notes — Modules & Workspaces

## 1. Terraform Modules

### 🧩 What is a Module?
A **module** in Terraform is a container for multiple Terraform files that work together as a single unit.  
Think of it like a **folder of reusable Terraform code**.

For example:
- You create an **EC2 instance module** once.
- You can reuse it in multiple environments (dev, test, prod).

A module typically includes:
```
main.tf
variables.tf
outputs.tf
```
All inside a folder = **one module**.

---

### 🏗️ Why Use Modules?
✅ Reuse same configuration for multiple environments  
✅ Keep Terraform code organized  
✅ Easier to maintain and scale  
✅ Share modules across teams (via Git or Terraform Registry)  

---

### 🧱 Types of Modules

| Type | Description | Example |
|------|--------------|----------|
| **Root Module** | The main Terraform configuration where execution begins | The folder where you run `terraform apply` |
| **Child Module** | Any module called from another module | A reusable “network” or “vm” module |
| **Published Module** | Pre-built modules shared on Terraform Registry | `source = "terraform-aws-modules/vpc/aws"` |

---

### 📦 How to Use a Module

#### Example Folder Structure
```
project/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    └── ec2-instance/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

#### Step 1: Define Module (Child Module)
**modules/ec2-instance/main.tf**
```hcl
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }
}
```

**variables.tf**
```hcl
variable "ami_id" {}
variable "instance_type" {}
variable "instance_name" {}
```

**outputs.tf**
```hcl
output "instance_id" {
  value = aws_instance.this.id
}
```

#### Step 2: Call Module (Root Module)
**main.tf**
```hcl
module "web_server" {
  source        = "./modules/ec2-instance"
  ami_id        = "ami-09d56f8956ab235b3"
  instance_type = "t2.micro"
  instance_name = "my-web-server"
}
```

#### Step 3: Use Output
**outputs.tf**
```hcl
output "web_id" {
  value = module.web_server.instance_id
}
```

Then run:
```bash
terraform init
terraform apply
```

Terraform automatically downloads and initializes the module.

---

### 🧰 Reusable Modules from Registry
You can use community modules like this:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
}
```

Terraform will automatically download it from the [Terraform Registry](https://registry.terraform.io/).

---

### 🪄 Tips for Modules
✅ Always create `variables.tf` and `outputs.tf`.  
✅ Use descriptive names for variables.  
✅ Test modules separately before using.  
✅ Store reusable modules in a Git repo or a central registry.  
✅ Keep modules small and focused (like microservices).  

---

## 2. Terraform Workspaces

### 🌍 What is a Workspace?
A **workspace** is like a separate copy of your Terraform state.  
It lets you use **one configuration** to manage **multiple environments** (like dev, stage, prod) without copying files.

Think of it like **folders inside Terraform Cloud or local system**, each having its own `.tfstate`.

---

### ⚙️ How It Works
- Same `.tf` files
- Different state file per workspace
- Keeps resources isolated

For example:
```
terraform.tfstate (for default workspace)
terraform.tfstate.d/dev/terraform.tfstate
terraform.tfstate.d/prod/terraform.tfstate
```

---

### 🧠 Example

**main.tf**
```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-app-${terraform.workspace}-bucket"
}
```

If you are in:
- `dev` workspace → Bucket name = `my-app-dev-bucket`
- `prod` workspace → Bucket name = `my-app-prod-bucket`

---

### 🪄 Commands

| Command | Description |
|----------|--------------|
| `terraform workspace list` | List all workspaces |
| `terraform workspace show` | Show current workspace |
| `terraform workspace new dev` | Create a new workspace |
| `terraform workspace select dev` | Switch workspace |
| `terraform workspace delete dev` | Delete a workspace |

---

### 📁 Workspace Directory Structure
When you create multiple workspaces, Terraform stores state like this:

```
terraform.tfstate.d/
├── dev/
│   └── terraform.tfstate
├── prod/
│   └── terraform.tfstate
```

---

### 🧩 When to Use Workspaces vs Modules

| Use Case | Recommended Approach |
|-----------|----------------------|
| Multiple environments (dev/test/prod) | Workspaces (for small setups) |
| Complex infrastructure, teams | Separate folders/modules + remote state |
| Reusing same infra in many projects | Modules |
| Isolated backend or access control | Separate state files/backends |

---

### 💡 Best Practices for Workspaces
✅ Name workspaces clearly (dev, stage, prod).  
✅ Use `${terraform.workspace}` in resource names.  
✅ Never mix environments in a single workspace.  
✅ Avoid workspaces for large orgs — use separate state files instead.  
✅ Store state remotely (S3, Azure Blob, GCS).

---

## 3. Quick Cheatsheet

| Concept | Command / Example | Description |
|----------|------------------|--------------|
| Create new module | `mkdir modules/ec2` | Define reusable logic |
| Use module | `module "web" { source="./modules/ec2" }` | Call in root |
| Registry module | `source = "terraform-aws-modules/vpc/aws"` | Download from registry |
| List workspaces | `terraform workspace list` | Show all |
| Create workspace | `terraform workspace new dev` | Add new |
| Switch workspace | `terraform workspace select prod` | Change environment |
| Show current | `terraform workspace show` | See active one |
| Workspace variable | `${terraform.workspace}` | Use in resource name |

---

### 🚀 Summary
- **Modules = Reusable Terraform Code Blocks.**
- **Workspaces = Separate State Environments.**
- Together, they help you manage **clean**, **scalable**, and **reusable** infrastructure.
