resource "aws_instance" "terraform" {
  ami           = "ami-09c813fb71547fc4f"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow-everything.id]

  tags = {
    Name = "Devops_86s"
  }
}

resource "aws_security_group" "allow-everything" {
  name   = "vikas"
  egress {
    from_port        = 0 #all ports
    to_port          = 0
    protocol         = "-1" #all protocals
    cidr_blocks      = ["0.0.0.0/0"] #internet
  }

  ingress {
    from_port        = 0 #all ports
    to_port          = 0
    protocol         = "-1" #all protocals
    cidr_blocks      = ["0.0.0.0/0"] #internet
  }
  tags = {
    Name = "allow-eveything"
  }
}