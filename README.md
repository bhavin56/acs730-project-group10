# acs730-project-group10


Final Project: Two-Tier web application automation with Terraform
-----------------------------------------------------------------


Terraform Deployment Pre-requisites:
-----------------------------------
1. Create three private S3 buckets to store the terraform state and images for dev, staging and prod environments. The names of the buckets must be:  
    i. dev-acs730-project-group10  
    ii. staging-acs730-project-group10  
    iii. prod-acs730-project-group10  
2. Create a folder named 'images' inside each bucket created in the last step. 
3. Upload three images with names: 'NiagaraFalls.jpeg', 'cntower.jpeg' and 'tobermory.jpeg' in the 'images' folder of each S3 bucket.
4. To login to Bastion via SSH, update the "my_private_ip" and "my_public_ip" variables in "variables.tf" file in location "acs730-project-group10/terraform/modules/security_groups/variables.tf" with your Cloud9 instance private and public IPv4 addresses.


Steps to deploy the infrastructure:
----------------------------------

**'dev' environment infrastructure deployment:**
1. After cloning the code in Cloud9, change the directory to dev network folder by giving the below command in the terminal:  
    cd acs730-project-group10/terraform/project/dev/network
2. Run "terraform init" to initialize the working directory
3. Run "terraform apply --auto-approve" command to deploy the dev network infrastructure. Wait for resources to deploy!
4. Once the network resources are deployed, change the directory from dev network to webserver folder by giving the command:  
    cd ../webserver
5. Create an SSH key-pair with name "Group10-dev" by giving the below command:  
    ssh-keygen -t rsa -f Group10-dev  
6. Run "terraform init" to initialize the working directory
7. Run "terraform apply --auto-approve" command to deploy all the resources defined in the config file including security groups, load balancer, launch configuration, auto scaling group and bastion host. Wait for resources to deploy!

**'staging' environment infrastructure deployment:** 
1. Change the directory to staging network folder by giving the below command in the terminal:  
    cd ../../staging/network
2. Run "terraform init" to initialize the working directory
3. Run "terraform apply --auto-approve" command to deploy the staging network infrastructure. Wait for resources to deploy!
4. Once the network resources are deployed, change the directory from staging network to staging webserver folder by giving the command:  
    cd ../webserver
5. Create an SSH key-pair with name "Group10-staging" by giving the below command:  
    ssh-keygen -t rsa -f Group10-staging
6. Run "terraform init" to initialize the working directory
7. Run "terraform apply --auto-approve" command to deploy all the resources defined in the config file including security groups, load balancer, launch configuration, auto scaling group and bastion host. Wait for resources to deploy!

**'prod' environment infrastructure deployment:** 
1. Change the directory to staging network folder by giving the below command in the terminal:  
    cd ../../prod/network  
2. Run "terraform init" to initialize the working directory
3. Run "terraform apply --auto-approve" command to deploy the prod network infrastructure. Wait for resources to deploy!
4. Once the network resources are deployed, change the directory from prod network to prod webserver folder by giving the command:  
    cd ../webserver  
5. Create an SSH key-pair with name "Group10-prod" by giving the below command:  
    ssh-keygen -t rsa -f Group10-prod  
6. Run "terraform init" to initialize the working directory
7. Run "terraform apply --auto-approve" command to deploy all the resources defined in the config file including security groups, load balancer, launch configuration, auto scaling group and bastion host. Wait for resources to deploy!


Steps to destroy the infrastructure:
------------------------------------

**Cleanup of prod resources:**
1. Change directory to prod webserver folder by giving the command: cd ~/environment/acs730-project-group10/terraform/project/prod/webserver
2. Run command "terraform destroy --auto-approve" to destroy all the resources. Wait for the cleanup to finish!
3. Change directory from prod webserver folder to prod network folder by giving the command: cd ../network
4. Run command "terraform destroy --auto-approve" to destroy all the network resources. Wait for the cleanup to finish!

**Cleanup of staging resources:**
1. Change directory to staging webserver folder by giving the command: cd ../../staging/webserver
2. Run command "terraform destroy --auto-approve" to destroy all the resources. Wait for the cleanup to finish!
3. Change directory from staging webserver folder to staging network folder by giving the command: cd ../network
4. Run command "terraform destroy --auto-approve" to destroy all the network resources. Wait for the cleanup to finish!

**Cleanup of dev resources:**
1. Change directory to dev webserver folder by giving the command: cd ../../dev/webserver
2. Run command "terraform destroy --auto-approve" to destroy all the resources. Wait for the cleanup to finish!
3. Change directory from dev webserver folder to dev network folder by giving the command: cd ../network
4. Run command "terraform destroy --auto-approve" to destroy all the network resources. Wait for the cleanup to finish!
 
