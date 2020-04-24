provider "aws" {
    region = "eu-west-1"
}

# create a VPC
#resource "aws_vpc" "app_vpc" {
#  cidr_block = "10.0.0.0/16"
#  tags = {
#      Name = "eng54-app-vpc"
#  }
#}

# use our devops vpc_security_group_ids
# "vpc-07e47e9d90d2076da"
# create new subnet
# move our instance into the subnet
resource "aws_subnet" "app_subnet" {
    vpc_id = "vpc-07e47e9d90d2076da"
    cidr_block = "172.31.50.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      Name = "zack-eng54-public-subnet"
    }
}

# Launching an instance

resource "aws_instance" "app_instance" {
    ami = "ami-040bb941f8d94b312"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.app_subnet.id
    vpc_security_group_ids = [aws_security_group.app_sg.id]
    tags = {
        Name = "eng54-zack-terraform"
    }
}

# creating a security group
resource "aws_security_group" "app_sg" {
  name        = "zack-app-security-group"
  description = "Allow 80 inbound traffic"
  vpc_id      = "vpc-07e47e9d90d2076da"

  tags = {
    Name = "zack-app-sg-tags"
  }

  ingress {
    description = "allows port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
