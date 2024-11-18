data "archive_file" "my_func_zip" {
  type             = "zip"
  source_dir       = "${path.module}/src"
  output_file_mode = "0660"
  output_path      = "/tmp/zip/myfunc-${var.tag}.zip"
}

resource "google_storage_bucket" "func_bucket" {
  name          = "${var.project_id}-func-zip"
  location      = var.region
  force_destroy = true
}

resource "google_storage_bucket_object" "archive" {
  name   = "myfunc-${var.tag}.zip"
  bucket = google_storage_bucket.func_bucket.name
  source = "/tmp/zip/myfunc-${var.tag}.zip"
}

resource "google_cloudfunctions2_function" "function" {
  name        = "myfunc"
  location    = var.region
  description = "my function"

  build_config {
    runtime     = "go122"
    entry_point = "HelloHTTP" # Set the entry point
    source {
      storage_source {
        bucket = google_storage_bucket.func_bucket.name
        object = google_storage_bucket_object.archive.name
      }
    }
  }

  service_config {
    min_instance_count = 0
    max_instance_count = 1
    available_cpu      = "80m"
    available_memory   = "135M"
    timeout_seconds    = 60
    environment_variables = {
      "PROJECT_ID" = var.project_id
      "TOPIC"      = var.topic
    }
    # service_account_email = google_service_account.account.email
  }
}

resource "google_cloud_run_service_iam_member" "cloud_run_invoker" {
  project  = google_cloudfunctions2_function.function.project
  location = google_cloudfunctions2_function.function.location
  service  = google_cloudfunctions2_function.function.name
  role     = "roles/run.invoker"
  member   = "allUsers"
  #   member   = "serviceAccount:${google_service_account.account.email}"
}
