terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.34"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "tf_ec2" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}

variable "aws-region" {
  type    = string
  default = "us-east-1"
}