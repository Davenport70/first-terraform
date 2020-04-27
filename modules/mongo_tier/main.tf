resource "aws_subnet" "mongo_subnet" {
    vpc_id = var.vpc_id
    cidr_block = "10.0.71.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      Name = var.name1
    }
}

# creating NACL
resource "aws_network_acl" "private-nacl" {
  vpc_id = var.vpc_id
  subnet_ids = [aws_subnet.mongo_subnet.id]

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.70.0/24"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "10.0.70.0/24"
    from_port  = 22
    to_port    = 22
  }


  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.70.0/24"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "10.0.70.0/24"
    from_port  = 22
    to_port    = 22
  }


  tags = {
    Name = "private"
  }
}
 # creating security groups
resource "aws_security_group" "mongo_sg" {
  name        = "zack-mongo-security-group"
  description = "Allow 27017 inbound traffic"
  vpc_id      = var.vpc_id


  ingress {
    description = "allows port 27017"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name1}-tags"
  }
}
# Route table
resource "aws_route_table" "private" {
  # it is associated with subnet_id
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name1}-private-table"
  }
}

resource "aws_route_table_association" "assoc" {
  subnet_id = aws_subnet.mongo_subnet.id
  route_table_id = aws_route_table.private.id
}

resource "aws_instance" "mongo_instance" {

    ami   = var.ami_id_private
    instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.mongo_subnet.id
    vpc_security_group_ids = [aws_security_group.mongo_sg.id]
    tags = {
        Name = var.name1
    }
    key_name = "zack-eng54"



}
