variable "vpc_id" {
  description = "This vpc's identification"
}

variable "name" {
  description = "This is the name for our ec2"
}

variable "ami_id_public" {
  description = "This is an ami ID"
}

variable "gateway_id" {
  description = "This is the internet gateway from querying our DB"
}

variable "db_ip" {
  description = "The db's ip"
}
