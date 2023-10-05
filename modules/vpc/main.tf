# creation of vpc
resource "aws_vpc" "my-vpc" {
    cidr_block = var.vpc_cidr
    instance_tenacy = default
    tags = {
      Name = "${var.project_name}-vpc"
    }
    enable_dns_hostnames = true               # boolean flags to enable/disable dns hostnames in the vpc
    enable_dns_support = true                 # boolean flags to enable/disable dns support in the vpc
}

# Internet-Gateway at attach with vpc-allows vpc to communicate with internet

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
     Name = "${var.project_name}-igw"
    }
}
data "aws_availability_zone" "available_zones"{

}

#creating public and private subnets
#public subnet-1
resource "aws_subnet" "pub_sub_1a" {
     vpc_id = aws_vpc.my_vpc.id
     cidr_block = var.pub_sub_1a_cidr
     availability_zone = aws_availability_zone.available_zones.names[0]
     map_public_ip_on_launch = true                                       #by default instances launched in this subnet will have public ip
     tags = {
       Name = "pub_sub_1a"
     }
}

resource "aws_subnet" "pub_sub_2b" {
     vpc_id = aws_vpc.my_vpc.id
     cidr_block = var.pub_sub_2b_cidr
     availability_zone =  aws_availability_zone.available_zones.names[1]
     map_public_ip_on_launch = true
     tags = {
       Name = "pub_sub_2b"
     }
}

# route-table

resource "aws_route_table" "rt" {
     vpc_id = aws_vpc.my_vpc.id
     route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
     }
     tags = {
       Name = "public-rt"
     }
}

# attaching route-table to both the public subnets
# public_subnet_1a
resource "aws_route_table_association" "rta_pubsub1a" {
     subnet_id = aws_subnet.pub_sub_1a.id
     route_table_id = aws_route_table.rt.id
}
# public_subnet_2b
resource "aws_route_table_association" "rta_pubsub2b" {
     subnet_id = aws_subnet.pub_sub_2b.id
     route_table_id = aws_route_table.rt.id
}

# creating private subnets

resource "aws_subnet" "prv_sub_3a" {
     vpc_id = aws_vpc.my_vpc.id
     cidr_block = var.prv_sub_3a_cidr
     availability_zone = aws_availability_zone.available_zones.names[0]
     tags =  {
       Name = "prv_sub_3a"
     }
}

resource "aws_subnet" "prv_sub_4b" {
    vpc_id =  aws_vpc.my_vpc.id
    cidr_block = var.prv_sub_4a_cidr
    availability_zone = aws_availability_zone.available_zones.names[1]
    tags = {
      Name = "prv_sub_4b"
    }
}

resource "aws_subnet" "prv_sub_5a" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.prv_sub_5a_cidr
    availability_zone = aws_availability_zone.available_zones.names[0]
    map_public_ip_on_launch = false
    tags = {
     Name = "prv_sub_5a"
    }
}

resource"aws_subnet" "prv_sub_6b" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.prv_sub_6b_cidr
    availability_zone = aws_availablitiy_zone.available_zones.names[1]
    map_public_ip_on_launch = false
    tags = {
     Name = "prv_sub_6b"
    }
}
