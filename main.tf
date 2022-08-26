resource "aws_vpc" "main-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "at&t-vpc"
  }
}

#code for subnets
resource "aws_subnet" "public-main-SN" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.0.0/24"
availability_zone = "us-east-1a"
map_public_ip_on_launch = true
  tags = {
    Name = "at&t-public-sn"
  }
}

#code for subnets
resource "aws_subnet" "private-main-SN1" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.1.0/24"
availability_zone = "us-east-1a"
map_public_ip_on_launch = false
  tags = {
    Name = "at&t-private-sn1"
  }
}


#code for subnets
resource "aws_subnet" "private-main-SN2" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "at&t-private-sn2"
  }
}

# code to build internet -gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "at&t-internat-gateway"
  }
}

# code for elastic IP for Nat-Gateway
resource "aws_eip" "main-NAT-EIP" {
  vpc      = true
  tags = {
    "Name" = "at&t-eip"
  }
}

# code for Nat-Gateway
resource "aws_nat_gateway" "main-NAT" {
  allocation_id = aws_eip.main-NAT-EIP.id
  subnet_id     = aws_subnet.public-main-SN.id

  tags = {
    Name = "at&t-nat-igw"
  }
  
  
}
    
# code for private rout table
resource "aws_route_table" "private-main-RT" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main-NAT.id
  }

  tags = {
    Name = "at&t-private-rt"
  }
}

#  private route table association
resource "aws_route_table_association" "private-rt-association1" {
  subnet_id      = aws_subnet.private-main-SN1.id
  route_table_id = aws_route_table.private-main-RT.id

}


#  private route table association
resource "aws_route_table_association" "private-rt-association2" {
  subnet_id      = aws_subnet.private-main-SN2.id
  route_table_id = aws_route_table.private-main-RT.id

}

# public route table and configure route
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = {
    Name = "at&t-public-rt"
  }
}

# public route table association
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-main-SN.id
  route_table_id = aws_route_table.public-rt.id
}






