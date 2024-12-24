resource "aws_vpc" "main" {
  cidr_block       = var.dev_vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "frontend" {
  count      = length(var.frontend_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.frontend_subnets[count.index]
  availability_zone = var.Availability_zones[count.index]

  tags = {
    Name = "${var.env}-frontend-subnet${count.index+1}"
  }
}
resource "aws_subnet" "backend" {
  count      = length(var.backend_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.backend_subnets[count.index]
  availability_zone = var.Availability_zones[count.index]

  tags = {
    Name = "${var.env}-backend-subnet${count.index+1}"
  }
}
resource "aws_subnet" "db" {
  count      = length(var.db_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_subnets[count.index]
  availability_zone = var.Availability_zones[count.index]

  tags = {
    Name = "${var.env}-db-subnet${count.index+1}"
  }
}

resource "aws_subnet" "public" {
  count      = length(var.public_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.Availability_zones[count.index]

  tags = {
    Name = "${var.env}-public-subnet${count.index+1}"
  }
}

resource "aws_route_table" "public" {
  count      = length(var.public_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block                = var.default_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
  }
  route {
    cidr_block                = "0.0.0.0/0"
    gateway_id                = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-rt${count.index+1}"
  }
}

resource "aws_route_table_association" "public" {
  count      = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}


resource "aws_vpc_peering_connection" "foo" {
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true

  tags = {
    Name = "peer"
  }
}
resource "aws_route" "dev-rt" {
  route_table_id            = aws_vpc.main.main_route_table_id
  destination_cidr_block    = "172.31.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
}
resource "aws_route" "default_rt" {
  route_table_id            = var.default_rout_table_id
  destination_cidr_block    = "10.10.0.0/24"
  vpc_peering_connection_id = aws_vpc_peering_connection.foo.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}