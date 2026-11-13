output "state_bucket_name" {
  description = "Ten S3 bucket luu Terraform State"
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
}

output "aws_region" {
  value = var.aws_region
}
