data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "golden-ami-*"
  owners           = ["self"]
}

# data "aws_security_group" "selected" {
#   name = "allow-all"
# }

data "vault_generic_secret" "ssh" {
  path = "common/common"
}