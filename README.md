# one-command-wordpress
1. Description

  Terraform and bash scripts which create sample Wordpress blog with single command.
  
  The solution consist the following main services:
  - Basic VPC
  - EC2 instances
  - Application Load Balancer
  - SSM Parameter Store parameters

---

2. Prerequisites

* You need to be authenticated against AWS and to have the needed IAM permissions
* Terraform binary installed (v0.12 version)

---

3. Steps to deploy the solution:

- Clone the repository <git clone https://github.com/kmarinov7/one-command-wordpress.git >
- Change the directory < cd one-command-wordpress >
- Initialize Terraform < terraform init >
- **Apply Terraform < terraform apply --auto-approve >**

---

4. Steps to destroy the solution:

- **Destroy Terraform < terraform destroy --auto-approve >** 

Note: sometimes the CW log group is not deleted due to bug in provider - check and delete manually if needed.

---

5. Management access
- fill the "key_name" variable
- add 22 port ingress rule in the wordpress SG
- apply

Note: you can use the web servers as bastion hosts if you need access to the database.

---

6. Future improvements
- EFS for the wordpress content
- Web nodes to be into private subnets
- Bastion host