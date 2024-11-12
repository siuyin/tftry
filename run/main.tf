terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.10.0"
    }
  }
}

provider "google" {
  project = "lsy1030"
  region  = var.region
}


module "storage" {
  source = "./modules/storage"
}

module "cloud_run" {
  source = "./modules/cloud_run"
  depends_on = [ module.storage ]
}

