provider "aws" {
  region = "us-east-1"
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
  name_prefix = "${var.prefix}-${var.env}"
}

#Creating an Auto scaling group for webservers
resource "aws_autoscaling_group" "web" {
  name                 = "${local.name_prefix}-AutoScalingGroup"
  min_size             = var.min_capacity
  desired_capacity     = var.desired_capacity
  max_size             = var.max_capacity
  target_group_arns    = [var.target_group_arn]
  launch_configuration = var.launch_config_name
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier = data.terraform_remote_state.network.outputs.private_subnet_ids

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-Webserver"
    propagate_at_launch = true
  }
  tag {
    key                 = "Owner"
    value               = var.default_tags.Owner
    propagate_at_launch = true
  }
  tag {
    key                 = "Env"
    value               = var.env
    propagate_at_launch = true
  }
}

#Policy to change autoscaling_groups according to alarm by cloudwatch

resource "aws_autoscaling_policy" "web_policy_up" {
  name                   = "web_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 180
  autoscaling_group_name = aws_autoscaling_group.web.name
}

#Configuring an alarm to be fired, if the total CPU utilization of all instances in our Auto Scaling Group will be the greater or equal to 10% during 120 seconds.
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name          = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_policy_up.arn]
}

resource "aws_autoscaling_policy" "web_policy_down" {
  name                   = "web_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 180
  autoscaling_group_name = aws_autoscaling_group.web.name
}

#Configuring an alarm to be fired, if the total CPU utilization of all instances in our Auto Scaling Group will be the lessthan or equal to 5% during 120 seconds.

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name          = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_policy_down.arn]
}