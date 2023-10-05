output "region" {
   value = var.region
}
output "project_name" {
   value = var.project_name
}
output "vpc_id" {
   value = aws_vpc.my_vpc.id
}
output "pub_sub_1a_id" {
   value = aws_subnet.pub_sub_1a.id
}
output "pub_sub_2b_id" {
   value = aws_subnet.pub_sub_2b.id
}
output "prv_sub_3a_id" {
   value = aws_subnet.prv_sub_3a.id
}
output "prv_sub_4b_id" {
   value = aws_subnet.prv_sub_4b.id
}
output "prv_sub_5a_id" {
   value = aws_subnet.prv_sub_5a.id
}
output "prv_sub_6b_id" {
   value = aws_subnet.prv_sub_6b.id
}
output "internet_gateway_id" {
   value = aws_internet_gateway.igw.id
}
