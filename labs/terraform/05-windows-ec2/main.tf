# Doc Default VPC
data "aws_vpc" "default" {
  default = true
}

# Tim cac default subnet thuoc VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

# Tim Windows Server 2022 AMI moi nhat cua Amazon
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


resource "aws_iam_role" "ec2_ssm" {
  name = "ntu-lab-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "ntu-lab-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm.name
}


resource "aws_security_group" "windows_ssm" {
  name        = "ntu-lab-windows-ssm-sg"
  description = "Windows EC2 - SSM only"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_egress_rule" "https" {
  security_group_id = aws_security_group.windows_ssm.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}



resource "aws_instance" "windows" {
  ami           = data.aws_ami.windows.id
  instance_type = var.instance_type

  subnet_id = sort(data.aws_subnets.default.ids)[0]

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.windows_ssm.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  # Dung CPU credit che do standard
  credit_specification {
    cpu_credits = "standard"
  }

  # Ma hoa o dia he dieu hanh
  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  # Bat buoc dung IMDSv2
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "ntu-lab-windows-ec2"
  }

  volume_tags = {
    Name = "ntu-lab-windows-root-ebs"
  }

  depends_on = [
    aws_iam_role_policy_attachment.ssm
  ]
}
