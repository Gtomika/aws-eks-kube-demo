# EKS requires some tags on the VPC and subnets
resource "aws_vpc" "demo_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "${var.app_name}-Vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "demo_public_subnets" {
  count = length(var.public_subnet_cidr_blocks)
  vpc_id = aws_vpc.demo_vpc.id
  availability_zone = var.availability_zones[count.index]
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  tags = {
    "Name" = "${var.app_name}-${var.availability_zones[count.index]}-Public"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "demo_private_subnets" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.demo_vpc.id
  availability_zone = var.availability_zones[count.index]
  cidr_block = var.private_subnet_cidr_blocks[count.index]
  tags = {
    "Name" = "${var.app_name}-${var.availability_zones[count.index]}-Private"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

# Creating gateway and route tables

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo_vpc.id
  tags = {
    Name = "${var.app_name}-IGW"
  }
}

resource "aws_route_table" "internet-route" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags  = {
    Name = "${var.app_name}-PublicRouteTable"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = element(aws_subnet.demo_public_subnets.*.id, count.index)
  route_table_id = aws_route_table.internet-route.id
}

