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

resource "google_container_cluster" "sg-gke" {
  name = "sg-gke"
  location = "asia-southeast1"
  deletion_protection = false
  enable_autopilot = true
}
