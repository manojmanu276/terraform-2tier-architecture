resource "aws_eip" "eip-nat-a" {
    vpc =  true
    tags = {
     Name = "eip-nat-a"
}
}

# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet pub-sub-2-b
resource "aws_eip" "eip-nat-b" {
    vpc = true
    tags = {
     Name = "eip-nat-b"
}
}

# Create a nat gateway in public subnet pub-sub-1-a
resource "aws_nat_gateway" "nat-a" {
  allocation_id = aws_eip.eip-nat-a.id
  subnet_id     = var.pub_sub_1a_id

  tags = {
    Name = "nat-a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.igw_id]
}

# Create a nat gateway in public subnet pub-sub-2-b
resource "aws_nat_gateway" "nat-b" {
  allocation_id = aws_eip.eip-nat-b.id
  subnet_id     = var.pub_sub_2b_id

  tags = {
    Name = "nat-b"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.igw_id]
}

# First Private Route table to create the flow from first nat gateway to 2 private subnets

resource "aws_route_table" "prv-rt-a" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-a.id
  }

  tags = {
    Name = "prv-rt-a"
  }
}

# Second Private Route table to create the flow from first nat gateway to next 2 private subnets
resource "aws_route_table" "prv-rt-b" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_internet_gateway.nat-b.id
  }


  tags = {
    Name = "prv-rt-b"
  }
}

# associate private subnet prv_sub_3a with private route table prv-rt-a
resource "aws_route_table_association" "prv-rt-a_prv_sub_3a" {
  subnet_id      = var.prv_sub_3a_id
  route_table_id = aws_route_table.prv-rt-a.id
}

#associate private subnet prv_sub_4b with private route table prv-rt-a
resource "aws_route_table_association" "prv-rt-a_prv_sub_4b" {
  subnet_id         = var.prv_sub_4b_id
  route_table_id    = aws_route_table.prv-rt-a.id
}

# associate private subnet prv_sub_5a with private route table prv-rt-b
resource "aws_route_table_association" "prv-rt-b_prv_sub_5a" {
  subnet_id         = var.prv_sub_5a_id
  route_table_id    = aws_route_table.prv-rt-b.id
}

# associate private subnet prv_sub_6b with private route table prv-rt-b
resource "aws_route_table_association" "prv-rt-b_prv_sub_6b" {
  subnet_id         = var.prv_sub_6b_id
  route_table_id    = aws_route_table.prv-rt-b.id
}
