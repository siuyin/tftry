resource "google_firestore_database" "main" {
  project     = var.project
  name        = "(default)"
  location_id = var.region
  type        = "FIRESTORE_NATIVE"
  delete_protection_state = "DELETE_PROTECTION_DISABLED"
  deletion_policy = "DELETE"
}
