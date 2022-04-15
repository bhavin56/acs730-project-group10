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

variable "my_private_ip" {
  type        = string
  default     = "172.31.3.88"
  description = "Private IP of my Cloud9 instance"
}

variable "my_public_ip" {
  type        = string
  default     = "3.222.117.150"
  description = "Public IP of my Cloud9 instance"
}