terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.5.2"
    }
  }
  required_version = ">= 1.8.0"
}

output "self_dir_exists" {
  value = provider::local::direxists("${path.module}/../local")
  #value = "${path.module}/terraform.tfstate"
}

data "local_file" "passwd" {
  filename = "/etc/passwd"
}

output "etc_passwd_contents" {
  value = data.local_file.passwd.content
}

