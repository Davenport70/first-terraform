# What is Terraform?

Terraform is an Orchestration Tool, that is part of infrastructure as code.

Where Chef and packer sit more on the Configuration Management side and create immutable AMI's.

Terraform sits on the orchestration side. The creation of networks and complex systems and deploys AMI's.

# How to use this Repository

To use this repo you will have to edit the AWS key_name to yours and its file location.

**Prerequisites**
Terraform
Git
AWS CLI 2

**To start you will need to clone the Repository**
git clone: 
Terraform Commands
To Initialise folder to use terraform use
terraform init
Test's to see if you have necessary AWS resources
terraform plan
Applies the changes on main.tf which run the app
terraform apply
To destroy all resources created by terraform
terraform destroy
Running Scripts
Template
To run scripts you would use, templates and, create a template file in that repo. The filename would be {name}.sh.tpl.

The Syntax is
data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"
  vars = {
    consul_address = "${aws_instance.consul.private_ip}"
  }
}
Remote Exec
Alternatively you could use remote exec which allows you to run inline commands but you will need to move over your key pair to allow AWS to use it to ssh into the machine to run the command.

The syntax is:
provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
