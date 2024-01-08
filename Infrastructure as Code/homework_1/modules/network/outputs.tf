output "router_nat_ip" {
  value = google_compute_router_nat.nat.nat_ip_allocate_option == "AUTO_ONLY" ? null : flatten(google_compute_router_nat.nat.source_subnetwork_ip_ranges_to_nat)[1].source_ip_ranges[1]
}

output "vpc_network_name" {
  value = google_compute_network.vpc_network.name
}

output "subnets_names" {
  value = google_compute_subnetwork.vpc_subnet[*].name
}

output "subnet_cidr_ranges" {
  value = google_compute_subnetwork.vpc_subnet[*].ip_cidr_range
}

output "router_id" {
  value = google_compute_router.router.id
}

output "router_nat_id" {
  value = google_compute_router_nat.nat.id
}

output "static_ip_address" {
  value = google_compute_address.static.address
}
