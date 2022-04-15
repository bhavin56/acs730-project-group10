terraform {
  backend "s3" {
    bucket = "staging-acs730-project-group10"
    key    = "staging-webserver/terraform.tfstate"
    region = "us-east-1"
  }
}