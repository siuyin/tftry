terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.10.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}


module "storage" {
  source = "./modules/storage"
  main_bucket = var.main_bucket
}

module "db" {
  source = "./modules/db"
  project = var.project_id
  region = var.region
}

module "cloud_run" {
  source = "./modules/cloud_run"
  depends_on = [ module.storage, module.db ]
  main_bucket = var.main_bucket
  image = var.image
  region = var.region
}

