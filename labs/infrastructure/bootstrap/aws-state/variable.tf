variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "bucket_suffix" {
  description = "Hau to phan biet S3 bucket"
  type        = string
  default     = "lab01"
}
