output "vpc_id" {
  value = aws_vpc.lab.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.lab.id
}

output "route_table_id" {
  value = aws_route_table.public.id
}

output "security_group_id" {
  value = aws_security_group.windows_ssm.id
}

output "instance_id" {
  value = aws_instance.windows.id
}

output "public_ip" {
  value = aws_instance.windows.public_ip
}

output "private_ip" {
  value = aws_instance.windows.private_ip
}

