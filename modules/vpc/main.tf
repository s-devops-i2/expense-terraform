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
resource "aws_vpc_peering_connection" "foo" {
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true

  tags = {
    Name = "peer"
  }
}