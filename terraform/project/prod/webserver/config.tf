terraform {
  backend "s3" {
    bucket = "prod-acs730-project-group10"
    key    = "prod-webserver/terraform.tfstate"
    region = "us-east-1"
  }
}