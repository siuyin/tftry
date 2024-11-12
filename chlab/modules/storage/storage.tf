resource "google_storage_bucket" "backend-bucket" {
  name          = "lsy1030-backend-bucket"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
}
