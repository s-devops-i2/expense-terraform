module "frontend" {
  depends_on    = [module.backend]
  source        = "./modules/apps"
  instance_type = var.instance_type
  component     ="frontend"
  env           = var.env
  zone_id       = var.zone_id
  vault_token   = var.vault_token
  subnets       = module.vpc.frontend_subnet
  vpc_id        = module.vpc.vpc_id
}

module "backend" {
  depends_on    = [module.mysql]

  source        = "./modules/apps"
  instance_type = var.instance_type
  component     ="backend"
  env           = var.env
  zone_id       = var.zone_id
  vault_token   = var.vault_token
  subnets       = module.vpc.backend_subnet
  vpc_id        = module.vpc.vpc_id
}
#
module "mysql" {
  source        = "./modules/apps"
  instance_type = var.instance_type
  component     ="mysql"
  env           = var.env
  zone_id       = var.zone_id
  vault_token   = var.vault_token
  subnets       = module.vpc.db_subnet
  vpc_id        = module.vpc.vpc_id
}

module "vpc" {
  source                = "./modules/vpc"
  dev_vpc_cidr_block        = var.dev_vpc_cidr_block
  env                   = var.env
  frontend_subnets      = var.frontend_subnets
  backend_subnets       = var.backend_subnets
  db_subnets            = var.db_subnets
  default_vpc_id        = var.default_vpc_id
  dev_route_table_id     = var.dev_route_table_id
  default_rout_table_id  = var.default_rout_table_id
  Availability_zones     = var.Availability_zones
}
