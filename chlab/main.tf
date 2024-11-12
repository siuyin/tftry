
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.85.0"
      #version = "6.10.0"
    }
  }

#  backend "gcs" {
#    bucket  = "lsy1030-backend-bucket"
#    prefix  = "terraform/state"
#  }
}

provider "google" {
  project = var.project_id
  region = var.region
  zone = var.zone
}


module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 6.0"

    project_id   = var.project_id
    network_name = "my-vpc"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-central1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-central1"
        },
    ]
}


resource "google_compute_firewall" "tf-firewall" {
  name    = "tf-firewall"
  network = "projects/lsy1030/global/networks/my-vpc"
  depends_on = [module.vpc]

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

}

module "instances" {
  source = "./modules/instances"
  depends_on = [module.vpc]
}

module "storage" {
  source = "./modules/storage"
}
