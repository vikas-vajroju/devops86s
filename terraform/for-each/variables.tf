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
  default = {
  mongodb = "t3.micro"
  redis = "t3.small"
  cart = "t2.micro"
  mysql ="t3.small"
}
}

variable "zone_id" {
  default = "Z0231025365MKU5GSP164"
  
}

variable "domain_name" {
  default = "devops86s.fun"
  
}

