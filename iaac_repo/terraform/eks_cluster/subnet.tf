resource "aws_subnet" "public_subnets" {

  count = length(var.public_subnet_cidrs)

  vpc_id = aws_vpc.file_api_vpc.id

  cidr_block = var.public_subnet_cidrs[count.index]

  availability_zone = var.availability_zones[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "file-api-public-${count.index + 1}"
    Type = "Public"
  }
}

resource "aws_subnet" "private_subnets" {

  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.file_api_vpc.id

  cidr_block = var.private_subnet_cidrs[count.index]

  availability_zone = var.availability_zones[count.index]

  map_public_ip_on_launch = false

  tags = {
    Name = "file-api-private-${count.index + 1}"
    Type = "Private"
  }
}