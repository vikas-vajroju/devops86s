resource "aws_instance" "Terraform" {
    ami           = "ami-09c813fb71547fc4f"
    instance_type = "t3.micro"
    tags = {
      Name = "terraform"
      Terraform = "true"
  }
}
