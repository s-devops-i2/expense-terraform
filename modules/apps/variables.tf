variable "instance_type" {}
variable "component" {}
variable "env" {}
variable "zone_id" {}
variable "vault_token" {}
variable "subnets" {}
variable "vpc_id" {}

variable "lb_type" {
  default = null
}
variable "lb_needed" {
  default = false
}
variable "lb_subnet" {
  default = null
}
variable "app_port" {
  default = null
}
variable "certificate_arn" {
  default = null
}
variable "lb_ports" {
  default = {}
}
variable "lb_app_port_sg_cidr" {
  default = []
}