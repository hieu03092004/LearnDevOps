terraform {
  backend "s3" {
    bucket       = "ntu-lab-tfstate-615299730549-ap-southeast-1-lab01"
    key          = "labs/03-security-group/terraform.tfstate"
    region       = "ap-southeast-1"
    profile      = "ntu-lab"
    encrypt      = true
    use_lockfile = true
  }
}
