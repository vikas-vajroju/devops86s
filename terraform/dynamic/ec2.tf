resource "aws_instance" "terraform" {
  ami           = data.aws_ami.joindevops.id
  instance_type = local.instance_type
  vpc_security_group_ids = [aws_security_group.allow-everything.id]

  tags = local.ec2_tags
  }


resource "aws_security_group" "allow-everything" {
  name   = "${local.common_name}-allow-all"
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