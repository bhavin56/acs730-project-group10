output "private_subnet_ids" {
  value = module.network-prod.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.network-prod.public_subnet_ids
}

output "vpc_id" {
  value = module.network-prod.vpc_id
}