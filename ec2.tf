provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "mysubnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"  
  map_public_ip_on_launch = true
}

resource "aws_security_group" "securitygroup" {
  name_prefix = "securitygroup-"
}

resource "aws_security_group_rule" "security_ingress" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.securitygroup.id
}

resource "aws_instance" "myec2" {
  ami           = "ami-0287a05f0ef0e9d9a" 
  instance_type = "t2.micro"             
  associate_public_ip_address = true
  key_name      = "myinstance" 

  vpc_security_group_ids = [aws_security_group.securitygroup.id]

  tags = {
    Name = "ec2-instance"
  }
}

