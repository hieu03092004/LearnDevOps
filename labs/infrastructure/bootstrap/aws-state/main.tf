
data "aws_caller_identity" "current" {}

locals {
  bucket_name = "ntu-lab-tfstate-${data.aws_caller_identity.current.account_id}-${var.aws_region}-${var.bucket_suffix}"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = local.bucket_name
  #khong tu xoa toan bo object de pha huy bucket
  force_destroy = false
  #end khong tu xoa toan bo object de pha huy bucket

  tags = {
    Name    = local.bucket_name
    Purpose = "TerraformRemoteState"
  }
  #ngan khong cho xoa bucket khi tien hanh thuc hien terraform destroy
  lifecycle {
    prevent_destroy = true
  }
  #end ngan khong cho xoa bucket khi tien hanh thuc hien terraform destroy
}

# ngan bucket hoac object duoc truy cap cong khai thong qua ACL hoac bucket policy
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
#end ngan bucket hoac object duoc truy cap cong khai thong qua ACL hoac bucket policy

# ma hoa du lieu khi luu tru
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
#end ma hoa du lieu khi luu tru


#luu lai versioning de co the revert ve version cu ,neu terraform.tfstate cua version moi luu du lieu sai
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
#end luu lai versioning de co the revert ve version cu ,neu terraform.tfstate cua version moi luu du lieu sai



