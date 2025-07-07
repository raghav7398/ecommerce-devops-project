provider "aws" {
 region = "us-east-1"
}

resource "aws_vpc" "demo-vpc" {
    cidr_block = var.vpc_cidr
    tags = {
      Name = var.vpc_name
    }
}

resource "aws_subnet" "pb-sub" {
    count = length(var.public_cidr)
    vpc_id = aws_vpc.demo-vpc.id
    cidr_block = var.public_cidr[count.index]
    map_public_ip_on_launch = true
    availability_zone = var.availability_zone[count.index]
    tags = {
      Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.demo-vpc.id
    tags = {
      Name = "${var.vpc_name}-igw"
    }
}

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.demo-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
      Name = "${var.vpc_name}-public-rt"
    }
  
}

resource "aws_route_table_association" "public-rt-asso" {
    count = length(var.public_cidr)
    subnet_id = aws_subnet.pb-sub[count.index].id
    route_table_id = aws_route_table.public-rt.id
  
}

resource "aws_subnet" "pt-sub" {
    vpc_id = aws_vpc.demo-vpc.id
    count = length(var.private_cidr)
    cidr_block = var.private_cidr[count.index]
    availability_zone = var.availability_zone[count.index]
    tags = {
      Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
    }
}

resource "aws_eip" "eip" {
  count = length(var.private_cidr)
  domain = "vpc"
  tags = {
    Name = "${var.vpc_name}-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "ngw" {
  count = length(var.private_cidr)
  subnet_id = aws_subnet.pb-sub[count.index].id
  allocation_id = aws_eip.eip[count.index].id
  tags = {
    Name = "${var.vpc_name}-ngw-${count.index + 1}"
  }
}

resource "aws_route_table" "private-rt" {
  count = length(var.availability_zone)
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw[count.index].id
  }
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
  
}

resource "aws_route_table_association" "private-rt-asso" {
  count = length(var.private_cidr)
  route_table_id = aws_route_table.private-rt[count.index].id
  subnet_id = aws_subnet.pt-sub[count.index].id
}