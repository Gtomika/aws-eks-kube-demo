resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.app_name}-Vpc"
  }
}

resource "aws_subnet" "demo_subnets" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.demo_vpc.id
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.app_name}-${var.availability_zones[count.index]}"
  }
}