provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-acs730-project-group10-1"
    key    = "${var.env}-network/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  name_prefix = "${var.prefix}-${var.env}"
}

data "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.env}-acs730-project-group10-1"
}

resource "aws_lb" "alb" {
  name               = "${local.name_prefix}-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = data.terraform_remote_state.network.outputs.public_subnet_ids
  
  #enable_deletion_protection = true
  drop_invalid_header_fields = true

  tags = {
    Name = "${local.name_prefix}-LoadBalancer",
  Env = var.env }
}

resource "aws_lb_target_group" "target_group" {
  name     = "${local.name_prefix}-TargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.network.outputs.vpc_id

  tags = {
    Name = "${local.name_prefix}-TargetGroup",
  Env = var.env }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}