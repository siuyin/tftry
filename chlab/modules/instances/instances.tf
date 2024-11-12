
resource "google_compute_instance" "tf-instance-1" {
  name = "tf-instance-1"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-12"
    }
  }

  network_interface {
    network = "my-vpc"
    subnetwork = "subnet-01"
    access_config {}
  }

  allow_stopping_for_update = true
}
