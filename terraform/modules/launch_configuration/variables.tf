variable "prefix" {
  type        = string
  description = "Name prefix"
}

variable "instance_type" {
  type        = string
  description = "EC2 Instance Type"
}

variable "env" {
  type        = string
  description = "Deployment Environment"
}

variable "sg_id" {
  type        = string
  description = "Webserver security group id"
}

