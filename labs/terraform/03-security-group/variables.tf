variable "aws_region" {
  description = "AWS Region cho bai lab"
  type        = string
  default     = "ap-southeast-1"
}

variable "my_ip_cidr" {
  description = "Public IPv4 cua may duoc phep truy cap"
  type        = string
}