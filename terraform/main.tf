terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-ruffnotes"
    key = "state/terraform.tfstate"
    region = "us-east-2"
  }
}


provider "aws" {
  profile                  = "vscode"
  region                   = "us-east-2"
}
