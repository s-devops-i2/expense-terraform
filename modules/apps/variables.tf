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
