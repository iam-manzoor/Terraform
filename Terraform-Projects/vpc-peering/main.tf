provider "aws" {
  region = "us-east-1"
}

module "webapp-vpc" {
  source = "./modules/vpc"

   vpc_name = "webapp_vpc_public"
   vpc_cidr = "10.1.0.0/16"
   availability_zones = ["us-east-1a","us-east-1b"]
   public_subnet_cidr = [ "10.1.1.0/24" ]
   private_subnet_cidr = [ "10.1.2.0/24", "10.1.3.0/24" ]
}

module "webapp-vpc-2" {
  source = "./modules/vpc"

   vpc_name = "webapp_vpc_private"
   vpc_cidr = "10.2.0.0/16"
   availability_zones = ["us-east-1b","us-east-1c"]
   public_subnet_cidr = [ "10.2.1.0/24" ]
   private_subnet_cidr = [ "10.2.2.0/24", "10.2.3.0/24" ]
}

module "vpc_peering" {
  source = "./modules/vpc-peering"

  requester_vpc_id          = module.webapp-vpc.vpc_id
  requester_vpc_cidr        = module.webapp-vpc.vpc_cidr
  requester_route_table_ids = module.webapp-vpc.route_table_ids

  accepter_vpc_id          = module.webapp-vpc-2.vpc_id
  accepter_vpc_cidr        = module.webapp-vpc-2.vpc_cidr
  accepter_route_table_ids = module.webapp-vpc-2.route_table_ids
}