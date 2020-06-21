# one-command-wordpress
####1. Description
Terraform and bash scripts which create Wordpress blog with single command.
The solution consist the following main services:
- Basic VPC
- EC2 instances
- SSM Parameter Store parameters

####2. Prerequisite
* You need to be authenticated against AWS and to have the needed IAM permissions

####3. Steps to deploy the solution:

- Clone the repository <git clone https://github.com/kmarinov7/one-command-wordpress.git >
- Change the directory < cd one-command-wordpress >
- Initialize Terraform < terraform init >
- **Apply Terraform < terraform apply --auto-approve >**

####4. Steps to destroy the solution:

- **Destroy Terraform < terraform destroy --auto-approve >**

P.S.: If you want management access to the instances, fill the variable 'key_name'