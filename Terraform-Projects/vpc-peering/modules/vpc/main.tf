resource "aws_vpc" "webapp-vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default"

    tags = {
        Name = var.vpc_name
    }
}

resource "aws_internet_gateway" "webapp-igw" {
    vpc_id = aws_vpc.webapp-vpc.id

    tags = {
        Name = "${var.vpc_name}-igw"
    }
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidr)
    vpc_id = aws_vpc.webapp-vpc.id
    cidr_block = element(var.public_subnet_cidr, count.index)
    availability_zone = var.availability_zones[0]

    tags = {
        Name = "${var.vpc_name}-public-subnet"
    }
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.webapp-vpc.id
    cidr_block = element(var.private_subnet_cidr, count.index)
    availability_zone = element(var.availability_zones, count.index)

    tags = {
        Name = "${var.vpc_name}-private-subnet"
    }
}

resource "aws_route_table" "webapp-public" {
    vpc_id = aws_vpc.webapp-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.webapp-igw.id
    }

    tags = {
        Name = "${var.vpc_name}-public-route-table"
    }
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidr)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.webapp-public.id
}

resource "aws_route_table" "webapp-private" {
    vpc_id = aws_vpc.webapp-vpc.id

    tags = {
        Name = "${var.vpc_name}-private-route-table"
    }
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidr)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.webapp-private.id
}
