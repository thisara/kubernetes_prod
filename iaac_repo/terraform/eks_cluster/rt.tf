resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.file_api_vpc.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.file_api_igw.id
  }

  tags = {
    Name = "file-api-public-rt"
  }
}

resource "aws_route_table_association" "public_association" {

  count = length(aws_subnet.public_subnets)

  subnet_id = aws_subnet.public_subnets[count.index].id

  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.file_api_vpc.id

  route {
    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.file_api_nat.id
  }

  tags = {
    Name = "file-api-private-rt"
  }
}

resource "aws_route_table_association" "private_association" {

  count = length(aws_subnet.private_subnets)

  subnet_id = aws_subnet.private_subnets[count.index].id

  route_table_id = aws_route_table.private_rt.id
}