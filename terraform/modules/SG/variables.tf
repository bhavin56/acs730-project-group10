variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags to add to all AWS resources"
}

variable "prefix" {
  type        = string
  description = "Name prefix"
}

variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment environment"
}

variable "vpc_id" {
  default     = ""
  type        = string
  description = "calling vpc_id for security group"
}