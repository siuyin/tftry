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

# ollama fails to find cuda drivers on debian
# data "aws_ami" "debian" {
#   most_recent = true
#   name_regex ="debian-12"
#   filter {
#     name = "architecture"
#     values = ["arm64"]
#   }
# }

resource "aws_instance" "siuyin" {
  #ami           = "ami-00d2a3841e190f297" # ubuntu 22.04, user: ubuntu
  ami           = "ami-0608188965cc1a3c8" # amazon linux 2023, user: ec2-user
  instance_type = "g5g.xlarge"
  key_name = "id_rsa"

  tags = {
    Name = "SiuYin"
  }
  root_block_device {
    #volume_size = 40
    volume_size = 65 # amazon linux needs 65GB or higher
    volume_type = "gp3"
  }
  user_data = <<-EOT
    #!/bin/sh
    sudo apt-get update
    sudo apt-get install tmux -y
    EOT
}
