variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags to add to all AWS resources"
}

variable "prefix" {
  type        = string
  description = "Name prefix"
}

variable "public_cidr_blocks" {
  type        = list(string)
  description = "Public Subnet CIDRs"
}

variable "private_cidr_blocks" {
  type        = list(string)
  description = "Private Subnet CIDRs"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR range"
}

variable "env" {
  default     = "Dev"
  type        = string
  description = "Deployment Environment"
}

