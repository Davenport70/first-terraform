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
git clone: git@github.com:Davenport70/first-terraform.git

*Terraform Commands*
To Initialise folder to use terraform use
```
terraform init
```
Test to see if you have necessary AWS resources
```
terraform plan
```
Applies the changes on main.tf which run the app
```
terraform apply
```
To destroy all resources created by terraform
```
terraform destroy
```
#To run the script

**Remote-Exec**
Using the *remote-exec* allows you to execute commands inside of the newly created ec2 so you can run your app.

```
provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
  ```
**Connection**
  You will need to use this alongside *connection* which allows you to access your ec2 with the ssh keys.

```
connection {
   type     = "ssh"
   user     = "root"
   host     = "self.public_ip"
   private_key = file("directory.private_key)"
 }
}
```
