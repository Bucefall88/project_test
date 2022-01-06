#----------------------------------------------------------------------- 
# Name:         project-test
# Version:      1.0
# Network settings     
#-----------------------------------------------------------------------
resource "aws_vpc" "vpc_test" {
  cidr_block = "10.10.0.0/24"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "vpc_test"
  }
}
# Create gateway
resource "aws_internet_gateway" "gw_test" {
  vpc_id = aws_vpc.vpc_test.id
    tags = {
    Name = "gw_test"
  }
}
# Create subnet
resource "aws_subnet" "subnet_test" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.10.0.0/24"
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.gw_test]
  tags = {
    Name = "subnet_test"
  }
}
# Create and edit route table
resource "aws_default_route_table" "rt_test" {
  default_route_table_id = aws_vpc.vpc_test.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_test.id
  }
  tags = {
    Name = "rt_test"
  }
}
