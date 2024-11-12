terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}

# Create a VPC
#resource "aws_vpc" "example" {
#  cidr_block = "10.0.10.0/24"
#  tags = {
#    name = "gerbau"
#  }
#}
data "aws_ami" "debian" {
  most_recent = true
  name_regex ="debian-12"
  filter {
    name = "architecture"
    values = ["arm64"]
    # values = ["x86_64"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "siuyin" {
  #ami           = data.aws_ami.ubuntu.id
  ami           = data.aws_ami.debian.id
  #ami           = "ami-03fa85deedfcac80b"  # ubuntu 22.04
  #ami           = "ami-0acbb557db23991cc"   # debian-12
  instance_type = "t4g.nano"
  key_name = "id_rsa"

  tags = {
    Name = "SiuYin"
  }
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  user_data = <<-EOT
    #!/bin/sh
    sudo apt-get update
    sudo apt-get install tmux postgresql -y
    EOT
}
