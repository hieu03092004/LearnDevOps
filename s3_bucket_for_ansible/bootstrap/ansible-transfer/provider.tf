terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.23.0, < 7.0.0"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "ntu-lab"

  default_tags {
    tags = {
      Project     = "NTU-DevOps"
      Environment = "lab"
      ManagedBy   = "Terraform"
    }
  }
}
