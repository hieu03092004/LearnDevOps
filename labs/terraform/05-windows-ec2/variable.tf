variable "aws_region" {
  description = "Region triển khai AWS"
  type        = string
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "Cau hinh Windows EC2"
  type        = string
  default     = "t3.small"
}
