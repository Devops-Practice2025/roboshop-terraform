## VPC
resource "aws_vpc" "default" {
    
cidr_block = var.default_cidr
tags = {
  name = "default-vpc"
}
}
resource "aws_subnet" "default_subnets" {
  count = length(var.default_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.default_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "default_subnet-${split("-" , var.availability_zones[count.index])[2]}"
  }

}


resource "aws_vpc" "main" {
    
cidr_block = var.cidr
tags = {
  name = "${var.env}-vpc"
}
  
}

## Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    name = "public-subnet-${split("-" , var.availability_zones[count.index])[2]}"
}

}
resource "aws_subnet" "web" {
  count = length(var.web_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.web_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    name = "web-subnet-${split("-" , var.availability_zones[count.index])[2]}"
}

}
resource "aws_subnet" "app" {
  count = length(var.app_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.app_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
   Name = "app-subnet-${split("-" , var.availability_zones[count.index])[2]}"
}

}

resource "aws_subnet" "db" {
  count = length(var.db_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.db_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "db-subnet-${split("-" , var.availability_zones[count.index])[2]}"
    
}

}