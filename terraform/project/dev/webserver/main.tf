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


module "global_vars" {
  source = "../../../modules/global_vars"
}

#Deploy security groups 
module "sg-dev" {
  source       = "../../../modules/SG"
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

#Deploy webserver launch configuration
module "launch-config-dev" {
  source        = "../../../modules/launch_configuration"
  prefix        = module.global_vars.prefix
  default_tags  = module.global_vars.default_tags
  env           = var.env
  sg_id         = module.sg-dev.web_sg_id
  instance_type = var.instance_type
}

#Deploy auto scaling group
module "asg-dev" {
  source             = "../../../modules/autoscaling_group"
  prefix             = module.global_vars.prefix
  env                = var.env
  default_tags       = module.global_vars.default_tags
  target_group_arn   = module.alb-dev.aws_lb_target_group_arn
  launch_config_name = module.launch-config-dev.launch_config_name
}
