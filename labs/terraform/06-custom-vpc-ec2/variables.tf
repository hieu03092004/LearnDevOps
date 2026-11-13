variable "aws_region" {
  description = "AWS Region cho lab"
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "Dai IPv4 cua VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "instance_type" {
  description = "Cau hinh Windows EC2"
  type        = string
  default     = "t3.small"
}
