output "webapp_vpc_public_vpc_id" {
  value = module.webapp-vpc.vpc_id
}

output "webapp_vpc_private_vpc_id" {
  value = module.webapp-vpc-2.vpc_id
}