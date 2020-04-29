provider "aws" {
    region = "eu-west-1"
}

# create a VPC
resource "aws_vpc" "app_vpc" {
 cidr_block = "10.0.0.0/16"
 tags = {
     Name = "${var.name}-vpc"
 }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.name}-ig"
  }
}
# we don't need a new IG -
# we can query our existing vpc/infrastructure with the 'data' handler function
# data "aws_internet_gateway" "default-gw" {
#   filter {
#     # on the hashicorp docs, it erferences AWS-API that has this filer "attachment.vpc-id"
#     name = "attachment.vpc-id"
#     values = [var.vpc_id]
#   }
# }

module "app" {
  source = "./modules/app_tier"
  vpc_id = aws_vpc.app_vpc.id
  name = var.name
  ami_id_public = var.ami_id_public
  gateway_id = aws_internet_gateway.igw.id
  db_ip = module.mongo.instance_ip_addr
  # gateway_id = data.aws_internet_gateway.default-gw.id
}
module "mongo" {
  source = "./modules/mongo_tier"
  vpc_id = aws_vpc.app_vpc.id
  name1 = var.name1
  ami_id_private = var.ami_id_private
  # gateway_id = data.aws_internet_gateway.default-gw.id
}
