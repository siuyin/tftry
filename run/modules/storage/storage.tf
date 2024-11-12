resource "google_storage_bucket" "main" {
  name          = "lsy1030-web"
  location      = "asia-southeast1"
  storage_class = "STANDARD"
  force_destroy = true
  versioning { enabled = false }
  soft_delete_policy { retention_duration_seconds = 0 }
}

resource "google_storage_bucket_object" "index" {
  name         = "public/index.html"
  content      = "<html><h1>hello world from google cloud storage</h1></html>"
  content_type = "text/html"
  bucket       = google_storage_bucket.main.id
}