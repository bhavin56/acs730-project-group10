variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags to add to all AWS resources"
}

variable "prefix" {
  type        = any
  description = "Name prefix"
}

variable "env" {
  type        = any
  description = "Deployment Environment"
}

variable "target_group_arn" {
  type        = string
  description = "calling load_balancers id"
}

variable "launch_config_name" {
  type        = string
  description = "calling template_name from launch config"
}

variable "min_capacity" {
  default     = 1
  type        = number
  description = "Minimum capacity of Auto scaling group"
}

variable "max_capacity" {
  default     = 4
  type        = number
  description = "Maximum capacity of Auto scaling group"
}

variable "desired_capacity" {
  default     = 2
  type        = number
  description = "Desired capacity of Auto scaling group"
}
