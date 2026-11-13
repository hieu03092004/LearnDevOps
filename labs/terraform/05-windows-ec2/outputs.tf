
output "instance_id" {
  value = aws_instance.windows.id
}

output "private_ip" {
  value = aws_instance.windows.private_ip
}

output "public_ip" {
  value = aws_instance.windows.public_ip
}

output "iam_role_name" {
  value = aws_iam_role.ec2_ssm.name
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_ssm.name
}

output "security_group_id" {
  value = aws_security_group.windows_ssm.id
}

output "ami_id" {
  value = data.aws_ami.windows.id
}
