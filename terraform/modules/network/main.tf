provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  default_tags = merge(var.default_tags, { "Env" = var.env })
  name_prefix  = "${var.prefix}-${var.env}"
}

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-VPC"
    }
  )
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_cidr_blocks)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index + 1]

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-PublicSubnet${count.index + 1}"
    }
  )
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index + 1]

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-PrivateSubnet${count.index + 1}"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.default_tags, {
    "Name" = "${local.name_prefix}-igw"
    }
  )
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-PublicRouteTable"
    }
  )
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

resource "aws_eip" "nat-eip" {
  vpc = true
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-eip"
    }
  )
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public_subnets[1].id
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-natgw"
    }
  )
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat-gw.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-PrivateRouteTable",
    }
  )
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnets[*].id)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}