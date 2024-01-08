output "compute_instance_internal_ip" {
  value = google_compute_instance.compute_instance.network_interface[0].network_ip
}

output "compute_instance_external_ip" {
  value = length(google_compute_instance.compute_instance.network_interface[0].access_config) > 0 ? google_compute_instance.compute_instance.network_interface[0].access_config[0].nat_ip : null
}