terraform {
  backend "s3" {
    bucket = "test-s3-terraform-use-case1" 
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}