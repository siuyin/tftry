resource "google_compute_instance" "default" {
  name                       = "sg1"
  machine_type               = "e2-micro"
  zone                       = var.zone
  key_revocation_action_type = "STOP"
  allow_stopping_for_update  = true
  tags                       = ["pg"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
    }
  }

  metadata = {
    startup-script = <<-EOT
      #! /bin/bash
      apt update
      apt install -y postgresql tmux

      sudo -u postgres psql -c "drop role if exists siuyin"
      sudo -u postgres psql -c "create role siuyin superuser login password '${var.passwd}'"
      sed -i -e "/^#listen_addresses/ilisten_addresses = '*'" /etc/postgresql/15/main/postgresql.conf
      sed -i -e '$ahost    all             siuyin          10.148.0.0/24           scram-sha-256\
      host    all             siuyin          14.100.118.31/32      scram-sha-256' /etc/postgresql/15/main/pg_hba.conf
      systemctl restart postgresql
      EOT
  }


  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

}

output "ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
