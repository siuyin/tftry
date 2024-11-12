terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.10.0"
    }
  }
}

provider "google" {
  project     = "lsy1030"
}

resource "google_storage_bucket" "mybucket" {
  name     = "siuyin-2024-11-06"
  location = "us-central1"
  storage_class = "REGIONAL"
  versioning { enabled = false }
  soft_delete_policy { retention_duration_seconds = 0 }
}
