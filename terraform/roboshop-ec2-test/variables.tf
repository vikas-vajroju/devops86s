variable "ami-id" {
    type = string
    default = "ami-09c813fb71547fc4f"
    description = "This is the AMI id for ec2 instance"
}

variable "instance_type" {
    type = string
    default = "t3.micro"
}

variable "sg_ids" {
    type = list
    default = ["sg-04e7bce75a2421209"]
}

variable "tags" {
    type = map
    default = {} # if default is empty, then it is optional
}