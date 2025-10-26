# Terraform Notes — Functions & State

## 1. Terraform Functions

### Overview
Terraform functions are built-in helpers to transform and compute values. They can be used in variables, locals, resources, data sources, and outputs.

**Syntax:**
```hcl
function_name(arg1, arg2, ...)
```

---

### Categories & Examples

#### String Functions
| Function | Description | Example |
|-----------|--------------|----------|
| `trimspace(s)` | Removes whitespace | `trimspace("  dev ") -> "dev"` |
| `chomp(s)` | Removes trailing newline | `chomp("dev
") -> "dev"` |
| `lower(s)` / `upper(s)` | Change case | `upper("dev") -> "DEV"` |
| `replace(s, old, new)` | Replace substring | `replace("dev", "d", "p") -> "pev"` |
| `format(fmt, args)` | String formatting | `format("%s-%02d", "app", 7) -> "app-07"` |

#### Collection Functions
| Function | Description | Example |
|-----------|--------------|----------|
| `length(list/map)` | Get number of elements | `length(["a","b"]) -> 2` |
| `concat(l1, l2)` | Combine lists | `concat(["a"],["b"]) -> ["a","b"]` |
| `join(sep, list)` | Join elements | `join("-", ["a","b"]) -> "a-b"` |
| `merge(m1, m2)` | Merge maps | `merge({a=1}, {b=2}) -> {a=1,b=2}` |
| `flatten(list)` | Flatten nested lists | `flatten([[1,2],[3]]) -> [1,2,3]` |

#### Numeric Functions
| Function | Description | Example |
|-----------|--------------|----------|
| `min()` / `max()` | Smallest/Largest value | `min(1,5,3) -> 1` |
| `ceil()` / `floor()` | Round up/down | `floor(1.8) -> 1` |
| `abs()` | Absolute value | `abs(-5) -> 5` |

#### Encoding & File
| Function | Description | Example |
|-----------|--------------|----------|
| `file(path)` | Read file | `file("user.txt")` |
| `base64encode(s)` | Encode to base64 | `base64encode("hello")` |
| `jsonencode(v)` | Convert to JSON | `jsonencode({a=1}) -> "{"a":1}"` |

#### Network Functions
| Function | Description | Example |
|-----------|--------------|----------|
| `cidrsubnet(cidr, newbits, num)` | Create subnet | `cidrsubnet("10.0.0.0/16",8,0)` |
| `cidrhost(cidr, num)` | Get host IP | `cidrhost("10.0.0.0/24",5)` |

#### Regex & Utility
| Function | Description | Example |
|-----------|--------------|----------|
| `regexall(pat, str)` | Find matches | `regexall("\d+","id123") -> ["123"]` |
| `timestamp()` | Current time | `"2025-10-26T09:45:00Z"` |
| `uuid()` | Random UUID | `"f47ac10b-..."` |

---

### Tips
- Use `locals {}` for readability.
- Avoid `timestamp()` or `uuid()` inside resources (cause diffs).
- Prefer deterministic functions for predictable plans.

---

## 2. Terraform State File

### Overview
Terraform state (`terraform.tfstate`) stores the mapping between configuration and real infrastructure.

**It includes:**
- Resource attributes and IDs
- Dependencies
- Outputs
- Module info

**State is JSON-based and sensitive — protect it!**

---

### Storage Options
| Type | Description |
|------|--------------|
| Local | Default, single-user |
| Remote (S3, Azure, GCS, Terraform Cloud) | Shared, versioned, locked |

Example (AWS S3 backend):
```hcl
terraform {
  backend "s3" {
    bucket         = "tf-state-bucket"
    key            = "project/env.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}
```

---

### Key Commands
| Command | Purpose |
|----------|----------|
| `terraform state list` | List resources in state |
| `terraform state show <addr>` | Show details |
| `terraform state mv old new` | Move resource |
| `terraform state rm <addr>` | Remove from state |
| `terraform import <addr> <id>` | Import existing infra |
| `terraform force-unlock <id>` | Remove stuck lock |
| `terraform state pull` | Get raw JSON state |

---

### Best Practices
✅ Use **remote backend** with locking and versioning.  
✅ Restrict state file access (contains secrets).  
✅ Avoid editing manually — use CLI tools.  
✅ Split states per environment/service.  
✅ Enable encryption (SSE, Blob encryption).  
✅ Use versioning for recovery.

---

## 3. Quick Cheatsheet

| Topic | Function/Command | Example |
|--------|------------------|----------|
| Join strings | `join("-", ["app","dev"])` | `"app-dev"` |
| List length | `length(var.list)` | `3` |
| Merge maps | `merge(map1,map2)` | `{}` |
| Create subnet | `cidrsubnet("10.0.0.0/16",8,1)` | `"10.0.1.0/24"` |
| Read file | `file("init.sh")` | file content |
| Base64 encode | `base64encode("test")` | `"dGVzdA=="` |
| Check resource state | `terraform state list` | Shows resources |
| Show details | `terraform state show aws_instance.web` | JSON attributes |
| Import resource | `terraform import aws_s3_bucket.demo demo-bucket` | Import existing infra |
| Move resource | `terraform state mv old new` | Rename safely |
| Lock fix | `terraform force-unlock <LOCK_ID>` | Release lock |

---

### Notes
- Do not commit `.tfstate` to Git.
- Treat `.tfstate` like a secret.
- Always back up remote state bucket.
- Use `locals` for complex expressions.