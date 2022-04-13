# Name prefix
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
