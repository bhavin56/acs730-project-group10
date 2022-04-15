variable "instance_type" {
  default     = "t3.small"
  description = "Type of the instance"
  type        = string
}

variable "env" {
  default     = "staging"
  type        = string
  description = "Deployment Environment"
}

variable "asg_desired_capacity" {
  default     = 3
  type        = string
  description = "Desired capacity of auto scaling group"
}
