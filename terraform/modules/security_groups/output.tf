output "lb_sg_id" {
  value = aws_security_group.sg_lb.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "web_sg_id" {
  value = aws_security_group.webserver_sg.id
}
