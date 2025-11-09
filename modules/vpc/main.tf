## VPC
##default
resource "aws_vpc" "default" {
    
cidr_block = var.default_cidr
tags = {
  Name = "default-vpc"
}
}
resource "aws_subnet" "default_subnets" {
  count = length(var.default_subnets)
  vpc_id = aws_vpc.default.id
  cidr_block = var.default_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "default_subnet-${split("-" , var.availability_zones[count.index])[2]}"
  }

}
resource "aws_route_table_association" "default" {
  count          = length(var.default_subnets)
  subnet_id      = aws_subnet.default_subnets.*.id[count.index]
  route_table_id = aws_route_table.default-rt.*.id[count.index]
}
resource "aws_vpc_peering_connection" "default_to_main" {
    peer_vpc_id = aws_vpc.main.id
    vpc_id      = aws_vpc.default.id
    auto_accept = true

}
resource "aws_internet_gateway" "default-igw" {
  vpc_id = aws_vpc.default.id
  tags = { Name = "default-igw"}
}

resource "aws_route_table" "default-rt" {
  count  = length(var.default_subnets)
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default-igw.id
  }

  route {
    cidr_block                = aws_vpc.main.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.default_to_main.id
  }

  tags = {
    Name = "default-rt-${split("-", var.availability_zones[count.index])[2]}"
  }
}

## Main vpc
resource "aws_vpc" "main" {
    
cidr_block = var.cidr
tags = {
  Name = "${var.env}-vpc"
}
  
}

## Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "public-subnet-${split("-" , var.availability_zones[count.index])[2]}"
}

}
resource "aws_subnet" "web" {
  count = length(var.web_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.web_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "web-subnet-${split("-" , var.availability_zones[count.index])[2]}"
}

}



resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "main-igw"}

}

## Route tables
resource "aws_route_table" "public-rt" {
  count  = length(var.public_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  route {
    cidr_block                = aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.default_to_main.id
  }

  tags = {
    Name = "public-rt-${split("-", var.availability_zones[count.index])[2]}"
  }
}


resource "aws_route_table" "web-rt" {
  count  = length(var.web_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-ngw.*.id[count.index]
  }

  route {
    cidr_block                = aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.default_to_main.id
  }

  tags = {
    Name = "web-rt-${split("-", var.availability_zones[count.index])[2]}"
  }
}

resource "aws_eip" "ngw-ip" {
  count  = length(var.availability_zones)
  domain = "vpc"
}

resource "aws_nat_gateway" "main-ngw" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.ngw-ip.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]

  tags = {
    Name = "nat-gw-${split("-", var.availability_zones[count.index])[2]}"
  }
}


## Route table association
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public-rt.*.id[count.index]
}

resource "aws_route_table_association" "web" {
  count          = length(var.web_subnets)
  subnet_id      = aws_subnet.web.*.id[count.index]
  route_table_id = aws_route_table.web-rt.*.id[count.index]
}
