data "aws_caller_identity" "current" {}

locals {
  bucket_name = "ntu-lab-ansible-transfer-${data.aws_caller_identity.current.account_id}-sg1"
}

resource "aws_s3_bucket" "ansible_transfer" {
  bucket        = local.bucket_name
  
  #terraform se tu choi xoa bucket neu trong bucket co >=1 object 
  force_destroy = false
  #end terraform se tu choi xoa bucket neu trong bucket co >=1 object
  #neu force_destroy = true thi khi thuc hien terraform destroy ,se tien hanh xoa tat ca cac object co trong bucket do truoc
  #sau khi tien hanh xoa tat ca cac object co trong bucket do,thi moi tien hanh xoa di bucket do 
  tags = {
    Name    = local.bucket_name
    Purpose = "AnsibleSSMTransfer"
  }
}
#khong cho cau hinh bucket hoac object thanh public qua ACL va bucket policy
resource "aws_s3_bucket_public_access_block" "ansible_transfer" {
  bucket = aws_s3_bucket.ansible_transfer.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
#end khong cho cau hinh bucket hoac object thanh public qua ACL va bucket policy

#ma hoa du lieu khi file duoc upload len S3
resource "aws_s3_bucket_server_side_encryption_configuration" "ansible_transfer" {
  bucket = aws_s3_bucket.ansible_transfer.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
#end ma hoa du lieu khi file duoc upload len S3

#ensure versioning disabled

resource "aws_s3_bucket_versioning" "ansible_transfer" {
  bucket = aws_s3_bucket.ansible_transfer.id

  versioning_configuration {
    status = "Disabled"
  }
}

#end ensure versioning disabled


#set up lifecycle delete object after one days
resource "aws_s3_bucket_lifecycle_configuration" "ansible_transfer" {
  bucket = aws_s3_bucket.ansible_transfer.id

  rule {
    id     = "delete-after-one-day"
    status = "Enabled"

    filter {}

    expiration {
      days = 1
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.ansible_transfer
  ]
}
#end setup lifecycle delete object after one days