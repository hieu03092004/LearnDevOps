output "transfer_bucket_name" {
  description = "S3 bucket for Ansible SSM transfers"
  value       = aws_s3_bucket.ansible_transfer.id
}

output "transfer_bucket_arn" {
  value = aws_s3_bucket.ansible_transfer.arn
}
