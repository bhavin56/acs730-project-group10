provider "aws" {
  region = "us-east-1"
}

locals {
  name_prefix = "${var.prefix}-${var.env}"
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_configuration" "web_config" {
  name                 = "${local.name_prefix}-LaunchConfig"
  image_id             = data.aws_ami.latest_amazon_linux.id
  instance_type        = var.instance_type
  security_groups      = [var.sg_id]
  key_name             = local.name_prefix
  iam_instance_profile = data.aws_iam_instance_profile.lab_profile.name
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      name   = var.default_tags.Owner,
      env    = upper(var.env),
      prefix = var.prefix
    }
  )
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
}

data "aws_iam_instance_profile" "lab_profile" {
  name = "LabInstanceProfile"
}