resource "aws_instance" "terraform" {
  ami           = var.ami-id
  instance_type = var.instance_type
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
    Name = "allow-everything"
  }
}