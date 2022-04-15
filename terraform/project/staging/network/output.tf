output "private_subnet_ids" {
  value = module.network-staging.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.network-staging.public_subnet_ids
}

output "vpc_id" {
  value = module.network-staging.vpc_id
}