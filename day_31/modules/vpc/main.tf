resource "aws_vpc" "yaksh_vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "yaksh-main-vpc"
  }
}

resource "aws_subnet" "yaksh_public" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.yaksh_vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "yaksh-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "yaksh_private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.yaksh_vpc.id
  cidr_block = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "yaksh-private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "yaksh_igw" {
  vpc_id = aws_vpc.yaksh_vpc.id
  tags = {
    Name = "yaksh-main-igw"
  }
}

resource "aws_route_table" "yaksh_public" {
  vpc_id = aws_vpc.yaksh_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.yaksh_igw.id
  }
  tags = {
    Name = "yaksh-public-route-table"
  }
}

resource "aws_route_table_association" "yaksh_public" {
  count = length(aws_subnet.yaksh_public)
  subnet_id = element(aws_subnet.yaksh_public.*.id, count.index)
  route_table_id = aws_route_table.yaksh_public.id
}