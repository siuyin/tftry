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
  main_bucket = var.main_bucket
}

module "cloud_run" {
  source = "./modules/cloud_run"
  depends_on = [ module.storage ]
  main_bucket = var.main_bucket
  image = var.image
  region = var.region
}

