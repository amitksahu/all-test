##
#public subnets

resource "aws_subnet" "public" {
  count = "${length(var.availability_zones)}"
  cidr_block = "${cidrsubnet(var.cidr_block,8,count.index)}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${element(var.availability_zones,count.index )}"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "Public subnet-${element(var.availability_zones,count.index )}"
  }
}


#########
#Private Subnet

resource "aws_subnet" "private" {
  cidr_block = "${cidrsubnet(var.cidr_block,8 ,count.index + length(var.availability_zones) )}"
  availability_zone = "${element(var.availability_zones,count.index )}"
  map_public_ip_on_launch = false
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    "Name" = "Private subnet-${element(var.availability_zones,count.index )}"
  }
}

resource "aws_eip" "nat" {
  count = "${length(var.availability_zones)}"
  vpc = true
}

resource "aws_nat_gateway" "main" {
  count = "${length(var.availability_zones)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index )}"
  subnet_id = "${element(aws_subnet.public.*.id,count.index )}"
}