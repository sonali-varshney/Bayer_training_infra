terraform {
  backend "s3" {
    bucket = "test-s3" 
    key    = "/dev"
    region = "us-east-1"
    #profile= ""
    use_lockfile = true
  }
}