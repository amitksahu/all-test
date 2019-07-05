###########
##Route table for public subnet traffic
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    "Name" = "Public Route Table"

  }
}

resource "aws_route" "publicinternetgateway" {
  route_table_id = "${aws_route_table.public.id}"
  gateway_id = "${aws_internet_gateway.main.id}"
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_route_table_association" "public" {
  count = "${length(var.availability_zones)}"
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${element(aws_subnet.public.*.id,count.index )}"
}


#########
#route for private subnets

resource "aws_route_table" "private" {
  count = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    "Name" = "Private Route Table-${element(var.availability_zones,count.index )}"
  }
}

resource "aws_route" "nat_gateway" {
  count = "${length(var.availability_zones)}"
  route_table_id = "${element(aws_route_table.private.*.id,count.index )}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.main.*.id,count.index )}"
}
resource "aws_route_table_association" "private" {
  count = "${length(var.availability_zones)}"
  route_table_id = "${element(aws_route_table.private.*.id,count.index )}"
  subnet_id = "${element(aws_subnet.private.*.id,count.index )}"
}