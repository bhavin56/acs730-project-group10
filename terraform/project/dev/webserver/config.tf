terraform {
  backend "s3" {
    bucket = "dev-acs730-project-group10"
    key    = "dev-webserver/terraform.tfstate"
    region = "us-east-1"
  }
}