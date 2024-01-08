resource "google_compute_instance" "compute_instance" {
  name         = var.vm_name
  machine_type = var.machine_type 
  zone         = var.zone_name

  boot_disk {
    initialize_params {
      image = var.disk_image
      size  = var.disk_size
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name

    access_config {
      nat_ip = var.static_ipv4_address
    }

  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_public_key)}"
  }
}