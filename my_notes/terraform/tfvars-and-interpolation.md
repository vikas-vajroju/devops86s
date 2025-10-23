
# 🌍 Terraform Deep Dive: `terraform.tfvars` & Interpolation

## 📘 1. What is `terraform.tfvars`?
The `terraform.tfvars` file is used to **define variable values** that Terraform automatically loads when running commands like `terraform plan` or `terraform apply`.

When you define variables in Terraform using the `variable` block, you can assign values in multiple ways — one of the most common and cleanest is through a `terraform.tfvars` file.

### 🧱 Example Setup

#### **variables.tf**
```hcl
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}
```

#### **terraform.tfvars**
```hcl
region         = "us-west-2"
instance_type  = "t2.micro"
```

#### **main.tf**
```hcl
provider "aws" {
  region = var.region
}

resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = var.instance_type
}
```

### 🧩 How Terraform Loads Variables
Terraform automatically looks for these filenames (in order):
1. `terraform.tfvars`
2. `terraform.tfvars.json`
3. Any `*.auto.tfvars` or `*.auto.tfvars.json`

✅ You can also load a custom file using:
```bash
terraform apply -var-file="custom.tfvars"
```

---

## ⚙️ 2. Interpolation in Terraform
Interpolation is how you **insert dynamic values** into Terraform configurations. It lets you refer to variables, resource attributes, outputs, and functions.

The syntax for interpolation:
```hcl
${ <EXPRESSION> }
```

### 🧠 Example 1: Using Variables
```hcl
resource "aws_s3_bucket" "example" {
  bucket = "${var.env}-bucket"
}
```
If `env = "dev"`, bucket name → `dev-bucket`

---

### 🧠 Example 2: Using Resource Attributes
```hcl
resource "aws_instance" "app" {
  ami           = "ami-12345"
  instance_type = var.instance_type
}

output "instance_public_ip" {
  value = aws_instance.app.public_ip
}
```
Here, `aws_instance.app.public_ip` dynamically gets the instance’s public IP.

---

### 🧠 Example 3: Using Built-in Functions
Terraform has many built-in functions that can be used within interpolation:

```hcl
resource "aws_s3_bucket" "example" {
  bucket = lower("${var.env}-Bucket-${var.project}")
}
```
✅ `lower()` converts all text to lowercase.

---

## 🧩 Modern Syntax (Terraform 0.12+)
In newer versions of Terraform, interpolation no longer requires `${}` in most cases.

Old way:
```hcl
bucket = "${var.env}-bucket"
```

New way:
```hcl
bucket = "${var.env}-bucket"  # Still works
bucket = var.env == "prod" ? "prod-bucket" : "dev-bucket"  # Recommended way
```

---

## 🪄 3. Conditional Expressions in Interpolation

You can use **ternary conditions** directly inside expressions:

```hcl
instance_type = var.env == "prod" ? "t3.large" : "t2.micro"
```

This means:
- If `env == "prod"`, use `t3.large`
- Else, use `t2.micro`

---

## 💡 4. Pro Tips

| Tip | Description |
|-----|--------------|
| 🗂️ Use `.auto.tfvars` | Auto-loaded by Terraform, helps organize environment-specific variables. |
| 🔒 Do not commit secrets | Keep secrets in environment variables or encrypted files, not in `tfvars`. |
| 🧪 Combine with workspaces | Use different `tfvars` files per environment (`dev.tfvars`, `prod.tfvars`). |
| 🧰 Use locals for readability | Define intermediate values using `locals {}` for cleaner interpolation. |

---

## 🧱 Example: Complete Project Structure

```
terraform-project/
├── main.tf
├── variables.tf
├── terraform.tfvars
├── dev.tfvars
├── prod.tfvars
└── outputs.tf
```

---

## 🧭 Summary

| Concept | Description |
|----------|--------------|
| `terraform.tfvars` | File to define variable values automatically picked up by Terraform. |
| Interpolation | Method to inject dynamic or computed values in Terraform code. |
| Expression Syntax | `${}` (old) or direct references (new). |
| Functions | `upper()`, `lower()`, `join()`, `length()`, `format()`, etc. |

---

**Next Topic:** 🌐 Terraform State, Backend & Locking — managing infrastructure state safely across teams.
