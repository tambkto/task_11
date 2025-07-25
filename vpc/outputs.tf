output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnet" {
  value = [for k in aws_subnet.public_subnet : k.id]
}
output "private_subnet" {
  value = [for k in aws_subnet.private_subnet : k.id]
}