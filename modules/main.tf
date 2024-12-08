module "frontend" {
  source = "./apps"
  instance_type = var.instance_type
  component     ="frontend"

}
