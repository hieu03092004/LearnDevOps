resource "aws_vpc" "lab" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ntu-lab-custom-vpc"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}
#create aws_subnet
resource "aws_subnet" "public" {
  
  #Subnet thuoc ve VPC vua tao
  vpc_id = aws_vpc.lab.id
  #end Subnet thuoc ve VPC vua tao 

  #Subnet co dai 256 dia chi IPV4
  cidr_block = "10.20.1.0/24"
  #End Subnet co dai 256 dia chi IPV4

  availability_zone = data.aws_availability_zones.available.names[0]

  # mac dinh cap Public IPV4 cho EC2 moi trong Subnet nay
  map_public_ip_on_launch = true
  # end mac dinh cap Public IPV4 cho EC2 moi trong Subnet nay 

  tags = {
    Name = "ntu-lab-public-subnet"
  }
}
#end create aws_subnet


#create aws_internet_gateway
#internet_gateway cung cap thanh phan giua VPC va Internet
resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "ntu-lab-custom-igw"
  }
}
#end create aws_internet_gateway

#create aws_route_table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab.id
  }

  tags = {
    Name = "ntu-lab-public-rt"
  }
}

#end create aws_route_table

#create aws_route_table_association

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#end create aws_route_table_association

#create security group
resource "aws_security_group" "windows_ssm" {
  name        = "ntu-lab-custom-windows-sg"
  description = "Windows EC2 with SSM access"
  vpc_id      = aws_vpc.lab.id

  tags = {
    Name = "ntu-lab-custom-windows-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "https" {
  security_group_id = aws_security_group.windows_ssm.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}
#end create security group

#create aws_instance

# Tim Windows Server 2022 AMI
data "aws_ami" "windows" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Lay Instance Profile cua bai 2.4
data "aws_iam_instance_profile" "ssm" {
  name = "ntu-lab-ec2-ssm-profile"
}

#end create aws_instance

#create EC2
resource "aws_instance" "windows" {
  ami           = data.aws_ami.windows.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.windows_ssm.id
  ]

  iam_instance_profile = data.aws_iam_instance_profile.ssm.name

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "ntu-lab-custom-windows-ec2"
  }

  depends_on = [
    aws_route_table_association.public,
    aws_vpc_security_group_egress_rule.https
  ]
}

#end create EC2