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
Atom

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

There is a terraform script which runs our app. Inside our main.tf we have two section which enable the template:
```
template = file("./scripts/app/init.sh.tpl")
```
and
```
user_data = data.template_file.app_init.rendered
```

*See the 'To run this Github Repository:' section at the end*

Alternately another method for running the app:

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
## To run this Github Repository:

**1**
ensure that you give a good name to your ami, edit the variable:
```
variable "name" {
  default = "INSERT-NAME"
}
```
**2**
```
terraform plan
```
**3**
```
terraform apply
```
**4**

To run this open a new browser and run the public ip of your newly created EC2. You can enter something like:

- (http://yourip:3000/fibonacci/10)
- (http://yourip:3000)
- (http://yourip:3000/posts)
