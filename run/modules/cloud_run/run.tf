data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_v2_service.main.location
  project  = google_cloud_run_v2_service.main.project
  service  = google_cloud_run_v2_service.main.name

  policy_data = data.google_iam_policy.noauth.policy_data
}


resource "google_cloud_run_v2_service" "main" {
  name                = var.main_bucket
  location            = var.region
  deletion_protection = false

  template {
    containers {
      image = var.image
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
        bucket = "lsy1030-web"
      }
    }
    max_instance_request_concurrency = 1000
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
    
  }
}