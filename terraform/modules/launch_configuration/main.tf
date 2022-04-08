provider "aws" {
  region = "us-east-1"
}

locals {
  name_prefix  = "${var.prefix}-${var.env}"
}

resource "aws_launch_configuration" "web_config" {
  name            = "${local.name_prefix}-Webserver"
  image_id        = "ami-087c17d1fe0178315"
  instance_type   = var.instance_type
  security_groups = [var.sg_id]
  #associate_public_ip_address = true
  user_data = <<EOF
     #!/bin/bash
     sudo yum update -y
     sudo yum install -y httpd
     sudo systemctl start httpd.service
     sudo systemctl enable httpd.service
     sudo echo "<h2>SAMPLE RESPONSE</h2>" > /var/www/html/index.html
   EOF
  lifecycle {
    create_before_destroy = true
  }
}