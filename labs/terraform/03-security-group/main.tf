# 1. Tim default VPC co san tren AWS
data "aws_vpc" "default" {
  default = true
}

# 2. Tao Security Group trong default VPC
resource "aws_security_group" "lab" {
  name        = "ntu-lab-sg"
  description = "Security group for Terraform lab"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "ntu-lab-sg"
  }
}

# 3. Chi cho phep IP cua ban truy cap TCP 8080
resource "aws_vpc_security_group_ingress_rule" "http_lab" {
  security_group_id = aws_security_group.lab.id
  cidr_ipv4         = var.my_ip_cidr
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
}

# 4. Cho phep ket noi HTTPS outbound
resource "aws_vpc_security_group_egress_rule" "https" {
  security_group_id = aws_security_group.lab.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}
