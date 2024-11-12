terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.5.2"
    }
  }
  required_version = ">= 1.8.0"
}

output "example_output" {
  # value = provider::local::direxists("${path.module}/ger")
  value = "${path.module}/ger"
}

