variable "ami-id" {
  default = "ami-09c813fb71547fc4f"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "common-tags" {
  default = {
    terraform = "true"
    project = "roboshop"
    environment = "dev"
  }
}

# variable "common_name" {
#   default = "${var.common-tags.project}-${var.common-tags.environment}"
# }