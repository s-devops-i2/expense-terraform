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
  lb_type       = "public"
  lb_needed     = true
  lb_subnet     = module.vpc.public_subnet
  app_port      = 80
  certificate_arn = var.certificate_arn
  bastion_nodes   = var.bastion_nodes
  prometheus_nodes = var.prometheus_nodes
  server_app_port_sg_cidr = var.public_subnets
  lb_app_port_sg_cidr     = ["0.0.0.0/0"]
  lb_ports                = {http: 80, https: 443}
}

module "backend" {
  depends_on    = [module.rds]

  source        = "./modules/apps"
  instance_type = var.instance_type
  component     ="backend"
  env           = var.env
  zone_id       = var.zone_id
  vault_token   = var.vault_token
  subnets       = module.vpc.backend_subnet
  vpc_id        = module.vpc.vpc_id
  lb_type       = "private"
  lb_needed     = true
  lb_subnet     = module.vpc.backend_subnet
  app_port       = 8080
  bastion_nodes  = var.bastion_nodes
  prometheus_nodes = var.prometheus_nodes
  server_app_port_sg_cidr = concat(var.frontend_subnets, var.backend_subnets)
  lb_app_port_sg_cidr     = var.frontend_subnets
  lb_ports                = {http: 8080}
}
module "rds" {
  source = "./modules/rds"

  allocated_storage         = 20
  component                 = "rds"
  engine                    = "mysql"
  engine_version            = "8.0.36"
  env                       = var.env
  family                    = "mysql8.0"
  instance_class            = "db.t3.micro"
  server_app_port_sg_cidr   = var.backend_subnets
  skip_final_snapshot       = true
  storage_type              = "gp3"
  subnet_ids                = module.vpc.db_subnet
  vpc_id                    = module.vpc.vpc_id
}
#
# module "mysql" {
#   source        = "./modules/apps"
#   instance_type = var.instance_type
#   component     ="mysql"
#   env           = var.env
#   zone_id       = var.zone_id
#   vault_token   = var.vault_token
#   subnets       = module.vpc.db_subnet
#   vpc_id        = module.vpc.vpc_id
#   app_port      = 3306
#   bastion_nodes  = var.bastion_nodes
#   prometheus_nodes = var.prometheus_nodes
#   server_app_port_sg_cidr     = var.backend_subnets
# }

module "vpc" {
  source                = "./modules/vpc"
  dev_vpc_cidr_block    = var.dev_vpc_cidr_block
  env                   = var.env
  frontend_subnets      = var.frontend_subnets
  backend_subnets       = var.backend_subnets
  db_subnets            = var.db_subnets
  public_subnets        = var.public_subnets
  default_vpc_id        = var.default_vpc_id
  default_vpc_cidr      = var.default_vpc_cidr
  dev_route_table_id    = var.dev_route_table_id
  default_rout_table_id = var.default_rout_table_id
  Availability_zones    = var.Availability_zones
}
