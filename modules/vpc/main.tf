resource "aws_vpc" "main" {
  cidr_block       = var.dev_vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.dev_subnet_cidr_block

  tags = {
    Name = "${var.env}-subnet"
  }
}
