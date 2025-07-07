output "vpc_id" {
    value = aws_vpc.demo-vpc.id

}

output "private_subnet_id" {
    value = aws_subnet.pt-sub[*].id
}

output "public_subnet_id" {
    value = aws_subnet.pb-sub[*].id
  
}