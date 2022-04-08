locals {
  default_tags = merge(var.default_tags, { "Env" = var.env })
  name_prefix  = "${var.prefix}-${var.env}"
}


#Security group for load balancer
resource "aws_security_group" "sg_lb" {
  description = "Security group for ELB"
  vpc_id      = var.vpc_id

  ingress {
    description = "port open for loadbalancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp" # HTTP access from anywhere
    cidr_blocks = ["172.31.59.184/32"]
  }

  egress {
    description = "Outbound allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["100.26.225.49/32"] # Outbound Rules
  }

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-LoadBalancer-sg"
  })
  lifecycle {
    create_before_destroy = true
  }
}




#Sec group for Bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id


  ingress {
    description = "SSH from admins"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.59.184/32"]
  }

  egress {
    description      = "Outbound allowed"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["100.26.225.49/32"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-Bastion-sg"
  })
}


#Sec group for Webserver hosts
resource "aws_security_group" "webserver_sg" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "port open for loadbalancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp" # HTTP access from anywhere
    cidr_blocks = ["172.31.59.184/32"]
  }

  egress {
    description      = "Outbound allowed"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["100.26.225.49/32"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-Webserver-sg"
  })
}
