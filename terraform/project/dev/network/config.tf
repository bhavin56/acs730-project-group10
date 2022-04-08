terraform {
  backend "s3" {
    bucket = "dev-acs730-project-group10"
    key    = "dev-network/terraform.tfstate"
    region = "us-east-1"
  }
}