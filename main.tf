module "frontend" {
  source = "./modules/apps"
  instance_type = var.instance_type
  component     ="frontend"
  ssh_user      = var.ssh_user
  ssh_password  = var.ssh_password
  env           = var.env
  zone_id       = var.zone_id

}
