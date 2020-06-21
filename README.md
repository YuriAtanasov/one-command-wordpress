# one-command-wordpress
1. Description

  Terraform and bash scripts which create sample Wordpress blog with single command.
  
  The solution consist the following main services:
  - Basic VPC
  - EC2 instances
  - Application Load Balancer
  - SSM Parameter Store parameters

2. Prerequisites

* You need to be authenticated against AWS and to have the needed IAM permissions
* Terraform binary installed (v0.12 version)

3. Steps to deploy the solution:

- Clone the repository <git clone https://github.com/kmarinov7/one-command-wordpress.git >
- Change the directory < cd one-command-wordpress >
- Initialize Terraform < terraform init >
- **Apply Terraform < terraform apply --auto-approve >**

4. Steps to destroy the solution:

- **Destroy Terraform < terraform destroy --auto-approve >** 

Note: sometimes the log group is not deleted due to bug in provider - check and delete manually if needed.

P.S.: If you want management access to the instances, fill the variable 'key_name' and uncomment/apply the ingress rule for 22 port in the SG.

 5 . Future improvements
- EFS for the wordpress content
- Web nodes to be into private subnets
- Bastion host