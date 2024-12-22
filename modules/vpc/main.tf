resource "aws_vpc" "main" {
  cidr_block       = var.dev_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.env}-vpc"
  }
}

