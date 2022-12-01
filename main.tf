terraform {
  backend "s3" {
    bucket = "fg-dev-configs"
    key = "test-tf-data-1/terraform.tf_state"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = "eu-north-1"
}

