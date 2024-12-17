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

resource "google_compute_instance" "default" {
  name                       = "sg1"
  machine_type               = "e2-micro"
  zone                       = var.zone
  key_revocation_action_type = "STOP"
  allow_stopping_for_update  = true
  tags                       = ["pg"]

  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/cos-cloud/global/images/cos-stable-117-18613-75-26"
      size  = 10
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

}

resource "google_compute_firewall" "default" {
  name    = "allow-postgres"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = [5432]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["pg"]
}
