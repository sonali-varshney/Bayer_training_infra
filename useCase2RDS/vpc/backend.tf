terraform {
  backend "s3" {
    bucket = "test-s3-terraform-use-case1" 
    key    = "dev/terraform.tfstate"    #Note  we have to give terraform.tfstate
    region = "us-east-1"
    #use_lockfile = true
  }
}
