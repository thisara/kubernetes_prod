resource "aws_internet_gateway" "file_api_igw" {

  vpc_id = aws_vpc.file_api_vpc.id

  tags = {
    Name = "file-api-igw"
  }
}