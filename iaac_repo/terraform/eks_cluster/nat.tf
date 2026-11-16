resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name        = "file-api-nat-eip"
  }
}

resource "aws_nat_gateway" "file_api_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name        = "file-api-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.file_api_igw
  ]
}