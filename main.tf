module "frontend" {
  depends_on    = [module.backend]
  source        = "./modules/apps"
  instance_type = var.instance_type
  component     ="frontend"
  env           = var.env
  zone_id       = var.zone_id
  vault_token   = var.vault_token

}

module "backend" {
  depends_on    = [module.mysql]

  source        = "./modules/apps"
  instance_type = var.instance_type
  component     ="backend"
  env           = var.env
  zone_id       = var.zone_id
  vault_token   = var.vault_token
}

module "mysql" {
  source        = "./modules/apps"
  instance_type = var.instance_type
  component     ="mysql"
  env           = var.env
  zone_id       = var.zone_id
  vault_token   = var.vault_token
}