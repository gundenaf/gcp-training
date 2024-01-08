resource "google_compute_firewall" "security_group" {
  name    = "${var.sg_name}-allow"
  network = var.network_name

  dynamic "allow" {
    for_each = var.ingress_ports
    content {
      protocol = "tcp"
      ports    = [allow.value]
    }
  }

  source_ranges = [var.source_ip_range]
}