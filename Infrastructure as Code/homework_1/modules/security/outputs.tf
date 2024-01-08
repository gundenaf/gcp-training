output "firewall_name" {
  value = google_compute_firewall.security_group.name
}

output "firewall_network" {
  value = google_compute_firewall.security_group.network
}

output "firewall_ingress_ports" {
  value = var.ingress_ports
}

output "firewall_source_ip_range" {
  value = var.source_ip_range
}