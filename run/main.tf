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

# There is a 300 second wait for re-creation after database deletion.
module "db" {
  source = "./modules/db"
  project = var.project_id
  region = var.region
}

module "storage" {
  source = "./modules/storage"
  main_bucket = var.main_bucket
}

# module "cloud_run" {
#   source = "./modules/cloud_run"
#   depends_on = [ module.storage, module.db ]
#   main_bucket = var.main_bucket
#   image = var.image
#   region = var.region
# }

resource "google_service_account" "gcf" {
  account_id = "gcf-sa"
  display_name = "cloud function service account"
}

# data "google_iam_policy" "run_invoker" {
#   binding {
#     role = "roles/cloudrun.invoker"
#     members = [google_service_account.gcf.email]
#   }
# }

# resource "google_cloudfunctions2_function_iam_policy" "run_invoker" {
#   project = 
# }


