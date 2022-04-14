# acs730-project-group10


Final Project: Two-Tier web application automation with Terraform
-----------------------------------------------------------------


Terraform Deployment Pre-requisites:
-----------------------------------
1. Create three S3 buckets to store the terraform state and images for dev, staging and prod environments. The names of the buckets must be:
    dev-acs730-project-group10
    staging-acs730-project-group10
    prod-acs730-project-group10
2. Create a folder named 'images' inside each bucket created in the last step. 
3. Upload three images with names: 'NiagaraFalls.jpeg', 'cntower.jpeg' and 'tobermory.jpeg' in the 'images' folder of each S3 bucket.


Steps to deploy the infrastructure:
----------------------------------

1. 'dev' environment infrastructure deployment: 
    1.1 After cloning the code in Cloud9, change the directory to dev network folder by giving the below command in the terminal:
        cd acs730-project-group10/terraform/project/dev/network
    1.2 Run "terraform init" to initialize the working directory
    1.3 Run "terraform apply --auto-approve" command to deploy the dev network infrastructure. Wait for resources to deploy!
    1.4 Once the network resources are deployed, change the directory from dev network to webserver folder by giving the command:
        cd ../webserver
    1.5 Create an SSH key-pair with name "Group10-dev" by giving the below command: 
        ssh-keygen -t rsa -f Group10-dev
    1.6 Run "terraform init" to initialize the working directory
    1.7 Run "terraform apply --auto-approve" command to deploy all the resources defined in the config file including security groups, load balancer,       launch configuration, auto scaling group and bastion host. Wait for resources to deploy!

2. 'staging' environment infrastructure deployment: 
    2.1 Change the directory to staging network folder by giving the below command in the terminal:
        cd ../../staging/network
    2.2 Run "terraform init" to initialize the working directory
    2.3 Run "terraform apply --auto-approve" command to deploy the staging network infrastructure. Wait for resources to deploy!
    2.4 Once the network resources are deployed, change the directory from staging network to staging webserver folder by giving the command:
        cd ../webserver
    2.5 Create an SSH key-pair with name "Group10-staging" by giving the below command: 
        ssh-keygen -t rsa -f Group10-staging
    2.6 Run "terraform init" to initialize the working directory
    2.7 Run "terraform apply --auto-approve" command to deploy all the resources defined in the config file including security groups, load balancer, launch configuration, auto scaling group and bastion host. Wait for resources to deploy!

3. 'staging' environment infrastructure deployment: 
    3.1 Change the directory to staging network folder by giving the below command in the terminal:
        cd ../../prod/network
    3.2 Run "terraform init" to initialize the working directory
    3.3 Run "terraform apply --auto-approve" command to deploy the prod network infrastructure. Wait for resources to deploy!
    3.4 Once the network resources are deployed, change the directory from prod network to prod webserver folder by giving the command:
        cd ../webserver
    3.5 Create an SSH key-pair with name "Group10-prod" by giving the below command: 
        ssh-keygen -t rsa -f Group10-prod
    3.6 Run "terraform init" to initialize the working directory
    3.7 Run "terraform apply --auto-approve" command to deploy all the resources defined in the config file including security groups, load balancer, launch configuration, auto scaling group and bastion host. Wait for resources to deploy!


Steps to destroy the infrastructure:
------------------------------------

1. Cleanup of dev resources:
    1.1 Change directory to dev webserver folder by giving the command: cd ~/environment/acs730-project-group10/terraform/project/dev/webserver
    1.2 Run command "terraform destroy --auto-approve" to destroy all the resources. Wait for the cleanup to finish.
    1.3 Change directory from dev webserver folder to dev network folder by giving the command: cd ../network
    1.4 Run command "terraform destroy --auto-approve" to destroy all the network resources. Wait for the cleanup to finish.

2. Cleanup of staging resources:
    2.1 Change directory to staging webserver folder by giving the command: cd ../../staging/webserver
    2.2 Run command "terraform destroy --auto-approve" to destroy all the resources. Wait for the cleanup to finish.
    2.3 Change directory from staging webserver folder to staging network folder by giving the command: cd ../network
    2.4 Run command "terraform destroy --auto-approve" to destroy all the network resources. Wait for the cleanup to finish.

3. Cleanup of prod resources:
    3.1 Change directory to prod webserver folder by giving the command: cd ../../prod/webserver
    3.2 Run command "terraform destroy --auto-approve" to destroy all the resources. Wait for the cleanup to finish.
    3.3 Change directory from prod webserver folder to prod network folder by giving the command: cd ../network
    3.4 Run command "terraform destroy --auto-approve" to destroy all the network resources. Wait for the cleanup to finish.
