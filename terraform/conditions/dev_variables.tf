variable "ami-id" {
  default = "ami-09c813fb71547fc4f"
}

# variable "instance_type" {
#   default = "t3.micro"
# }

variable "environment" {
  default = "dev"
}

variable "tags" {
  default = {
    Name = "Devops_86s"
    environment="dev"
    region="eastus"
  }
}