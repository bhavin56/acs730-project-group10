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