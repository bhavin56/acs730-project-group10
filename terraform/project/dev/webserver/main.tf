terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 2.7.0"
      configuration_aliases = [aws.alternate]
    }
  }
}

# Data source for AMI id to use for Bastion
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Use remote state to retrieve the data
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-acs730-project-group10-1"
    key    = "${var.env}-network/terraform.tfstate"
    region = "us-east-1"
  }
}

module "global_vars" {
  source = "../../../modules/global_vars"
}

#Deploy security groups 
module "sg-dev" {
  source       = "../../../modules/SG"
  vpc_id       = data.terraform_remote_state.network.outputs.vpc_id
  prefix       = module.global_vars.prefix
  default_tags = module.global_vars.default_tags
  env          = var.env
}

#Deploy application load balancer
module "alb-dev" {
  source       = "../../../modules/load_balancer"
  prefix       = module.global_vars.prefix
  default_tags = module.global_vars.default_tags
  env          = var.env
  sg_id        = module.sg-dev.lb_sg_id
}

#Deploy application launch configuration
module "launch-config-dev" {
  source        = "../../../modules/launch_configuration"
  prefix        = module.global_vars.prefix
  env           = var.env
  sg_id         = module.sg-dev.web_sg_id
  instance_type = var.instance_type
}