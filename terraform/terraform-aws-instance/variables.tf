variable "ami-id" {
    type = string
    #default = "ami-09c813fb71547fc4f"
    description = "This is the AMI id for ec2 instance"
}

variable "instance_type" {
    type = string
    #default = "t3.micro"
}

variable "sg_ids" {
    type = list
    #default = [aws_security_group.allow-everything.id]
}

variable "tags" {
    type = map
    default = {} # if default is empty, then it is optional
}