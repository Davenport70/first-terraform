# move here anything to do with the app tier

resource "aws_subnet" "app_subnet" {
    vpc_id = var.vpc_id
    cidr_block = "10.0.70.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      Name = var.name
    }
}

# creating NACL
resource "aws_network_acl" "public-nacl" {
  vpc_id = var.vpc_id
  subnet_ids = [aws_subnet.app_subnet.id]

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 433
    to_port    = 433
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "90.252.32.133/32"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
  protocol   = "tcp"
  rule_no    = 140
  action     = "allow"
  cidr_block = "0.0.0.0/0"
  from_port  = 3000
  to_port    = 3000
}

ingress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "10.0.71.0/24"
    from_port  = 27107
    to_port    = 27107
  }

  tags = {
    Name = "main"
  }
}
 # creating security groups
resource "aws_security_group" "app_sg" {
  name        = "zack-app-security-group"
  description = "Allow 80 inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "allows port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allows port 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["90.252.32.133/32"]
  }
  ingress {
    description = "port 443 from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    description = "allows port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["90.252.32.133/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-tags"
  }
}
# Route table
resource "aws_route_table" "public" {
  # it is associated with subnet_id
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }
  tags = {
    Name = "${var.name}-public-table"
  }
}

resource "aws_route_table_association" "assoc" {
  subnet_id = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.public.id
}

# creating the template file link
data "template_file" "app_init" {
  template = file("./scripts/app/init.sh.tpl")

  vars = {
    db_priv_ip = var.db_ip
  }
  # set ports
  # for the mongod db, setting private_ip for posts
  # AWS gives us new ips
}

# Launching an instance
resource "aws_instance" "app_instance" {
    ami = var.ami_id_public
    instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.app_subnet.id
    vpc_security_group_ids = [aws_security_group.app_sg.id]
    tags = {
        Name = var.name
    }
    key_name = "zack-eng54"

    user_data = data.template_file.app_init.rendered
    }


#   provisioner "remote-exec" {
#     inline = [
#       "cd /home/ubuntu/app",
#       "npm start"
#     ]
#   }
#   connection {
#     type = "ssh"
#     user = "ubuntu"
#     host = self.public_ip
#     private_key = file("~/.ssh/zack-eng54.pem")
#   }
