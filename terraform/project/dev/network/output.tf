output "private_subnet_ids" {
  value = module.network-dev.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.network-dev.public_subnet_ids
}

output "vpc_id" {
  value = module.network-dev.vpc_id
}