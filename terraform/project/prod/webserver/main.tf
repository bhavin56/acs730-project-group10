provider "aws" {
  region = "us-east-1"
}

module "global_vars" {
  source = "../../../modules/global_vars"
}

#Deploy security groups 
module "sg-prod" {
  source       = "../../../modules/security_groups"
  prefix       = module.global_vars.prefix
  default_tags = module.global_vars.default_tags
  env          = var.env
}

#Deploy application load balancer
module "alb-prod" {
  source       = "../../../modules/load_balancer"
  prefix       = module.global_vars.prefix
  default_tags = module.global_vars.default_tags
  env          = var.env
  sg_id        = module.sg-prod.lb_sg_id
}

#Deploy webserver launch configuration
module "launch-config-prod" {
  source        = "../../../modules/launch_configuration"
  prefix        = module.global_vars.prefix
  default_tags  = module.global_vars.default_tags
  env           = var.env
  sg_id         = module.sg-prod.web_sg_id
  instance_type = var.instance_type
}

#Deploy auto scaling group
module "asg-prod" {
  source             = "../../../modules/autoscaling_group"
  prefix             = module.global_vars.prefix
  env                = var.env
  default_tags       = module.global_vars.default_tags
  desired_capacity   = var.asg_desired_capacity
  target_group_arn   = module.alb-prod.aws_lb_target_group_arn
  launch_config_name = module.launch-config-prod.launch_config_name
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-acs730-project-group10"
    key    = "${var.env}-network/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  default_tags = merge(module.global_vars.default_tags, { "Env" = var.env })
  name_prefix  = "${module.global_vars.prefix}-${var.env}"
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

#Deploy Bastion Host
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = local.name_prefix
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  security_groups             = [module.sg-prod.bastion_sg_id]
  associate_public_ip_address = true
  ebs_optimized               = true
  monitoring                  = true

  root_block_device {
    encrypted = true
  }

  #added to enable Instance Metadata Service V2 (checkov error)
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-Bastion"
    }
  )
}

resource "aws_key_pair" "web_key" {
  key_name   = local.name_prefix
  public_key = file("${local.name_prefix}.pub")
}

