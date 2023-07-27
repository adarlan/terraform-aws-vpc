resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = merge(
    var.tags,
    var.vpc_tags,
    {
      Name = "${var.name_prefix}-vpc"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.tags,
    var.internet_gateway_tags,
    {
      Name = "${var.name_prefix}-internet-gateway"
    }
  )
}

data "aws_availability_zones" "available" {}

locals {
  available_az_count   = length(data.aws_availability_zones.available)
  az_count             = min(var.max_az_count, local.available_az_count)
  public_subnet_count  = local.az_count
  private_subnet_count = local.az_count
  nat_gateway_count    = min(var.max_nat_gateway_count, local.private_subnet_count)
}

resource "aws_subnet" "public" {
  count                   = local.public_subnet_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    var.public_subnet_tags,
    {
      Name = format("%s-%s-%s", var.name_prefix, "public-subnet", data.aws_availability_zones.available.names[count.index])
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    var.tags,
    var.public_route_table_tags,
    {
      Name = "${var.name_prefix}-public-route-table"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = local.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count             = local.private_subnet_count
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, local.public_subnet_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    var.tags,
    var.private_subnet_tags,
    {
      Name = format("%s-%s-%s", var.name_prefix, "private-subnet", data.aws_availability_zones.available.names[count.index])
    }
  )
}

resource "aws_eip" "nat_eip" {
  count = local.nat_gateway_count
  vpc   = true
  tags = merge(
    var.tags,
    var.nat_eip_tags,
    {
      Name = format("%s-%s-%s", var.name_prefix, "nat-eip", data.aws_availability_zones.available.names[count.index])
    }
  )
}

resource "aws_nat_gateway" "nat_gw" {
  count         = local.nat_gateway_count
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = merge(
    var.tags,
    var.nat_gateway_tags,
    {
      Name = format("%s-%s-%s", var.name_prefix, "nat-gateway", data.aws_availability_zones.available.names[count.index])
    }
  )
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  count  = local.nat_gateway_count
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }
  tags = merge(
    var.tags,
    var.private_route_table_tags,
    {
      Name = format("%s-%s-%s", var.name_prefix, "private-route-table", data.aws_availability_zones.available.names[count.index])
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = local.nat_gateway_count == 0 ? 0 : local.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index % local.nat_gateway_count].id
}
