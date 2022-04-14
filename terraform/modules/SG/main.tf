locals {
  default_tags = merge(var.default_tags, { "Env" = var.env })
  name_prefix  = "${var.prefix}-${var.env}"
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-acs730-project-group10"
    key    = "${var.env}-network/terraform.tfstate"
    region = "us-east-1"
  }
}

#Security group for load balancer
resource "aws_security_group" "sg_lb" {
  name        = "allow_http"
  description = "Allow HTTP for all users"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Outbound Rules
  }

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-LoadBalancer-sg"
  })
  lifecycle {
    create_before_destroy = true
  }
}

#Security group for Bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description = "SSH from admins"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # update with Cloud9 public and private IP
  }

  egress {
    description      = "Outbound allowed"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-Bastion-sg"
  })
}

#Security group for Webserver hosts
resource "aws_security_group" "webserver_sg" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description     = "HTTP from Load balancer and Bastion"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_lb.id, aws_security_group.bastion_sg.id]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    description = "Outbound allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-Webserver-sg"
  })
}