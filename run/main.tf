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

resource "google_storage_bucket" "web-bucket" {
  name          = var.web-bucket
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true
  versioning { enabled = false }
  soft_delete_policy { retention_duration_seconds = 0 }
}

resource "google_storage_bucket_object" "default" {
  name         = "public/index.html"
  content      = "<html><h1>hello world from google cloud storage</h1></html>"
  content_type = "text/html"
  bucket       = google_storage_bucket.web-bucket.id
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_v2_service.web-bucket.location
  project  = google_cloud_run_v2_service.web-bucket.project
  service  = google_cloud_run_v2_service.web-bucket.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_cloud_run_v2_service" "web-bucket" {
  name                = "web-bucket"
  location            = var.region
  deletion_protection = false

  template {
    containers {
      image = var.web-image
      volume_mounts {
        name       = "webdata"
        mount_path = "/tmp/data/"
      }
      resources {
        cpu_idle = true
        startup_cpu_boost = true
        limits = {
          cpu = 1
          memory = "512Mi"
        }
      }
    }
    volumes {
      name = "webdata"
      gcs {
        bucket = google_storage_bucket.web-bucket.name
      }
    }
    max_instance_request_concurrency = 1000
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
    
  }
}

