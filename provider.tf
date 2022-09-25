provider "aws" {
#   profile = "myawsaccount"
  region  = "us-west-2"
}

terraform {
  cloud {
    organization = "techieinyou"
    workspaces {
      name = "lambdalayer-requests-python-prod"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.32"
    }
  }

}
