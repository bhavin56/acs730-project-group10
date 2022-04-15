terraform {
  backend "s3" {
    bucket = "staging-acs730-project-group10"
    key    = "staging-network/terraform.tfstate"
    region = "us-east-1"
  }
}