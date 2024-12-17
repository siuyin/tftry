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