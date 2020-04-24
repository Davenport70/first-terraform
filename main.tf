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
    vpc_id = var.vpc_id
    cidr_block = "172.31.50.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      Name = var.name
    }
}

# Route table
resource "aws_route_table" "public" {
  # it is associated with subnet_id
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default-gw.id
  }
  tags = {
    Name = "${var.name}-public-table"
  }
}

resource "aws_route_table_association" "assoc" {
  subnet_id = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.public.id
}

# we don't need a new IG -
# we can query our existing vpc/infrastructure with the 'data' handler function
data "aws_internet_gateway" "default-gw" {
  filter {
    # on the hashicorp docs, it erferences AWS-API that has this filer "attachment.vpc-id"
    name = "attachment.vpc-id"
    values = [var.vpc_id]

  }
}

# Launching an instance

resource "aws_instance" "app_instance" {
    ami = var.ami_id
    instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.app_subnet.id
    vpc_security_group_ids = [aws_security_group.app_sg.id]
    tags = {
        Name = var.name
    }
}

# creating a security group
resource "aws_security_group" "app_sg" {
  name        = "zack-app-security-group"
  description = "Allow 80 inbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-tags"
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
