variable "ami-id" {
  default = "ami-09c813fb71547fc4f"
}

# variable "instance_type" {
#   default = "t3.micro"
# }

variable "environment" {
  default = "dev"
}

variable "instances" {
  default = ["mongodb","redis","cart","mysql"]
}

variable "zone_id" {
  default = "Z0231025365MKU5GSP164"
  
}

variable "domain_name" {
  default = "devops86s.fun"
  
}