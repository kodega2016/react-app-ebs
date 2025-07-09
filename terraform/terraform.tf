terraform {
  backend "s3" {
    bucket = "kodega-terraform-state"
    key    = "react-app-ebs"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }
}
