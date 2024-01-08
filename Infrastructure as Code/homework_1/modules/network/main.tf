resource "google_compute_network" "vpc_network" {
  name                            = "${var.vpc_name}-vpc"
  delete_default_routes_on_create = false
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
}

resource "google_compute_address" "static" {
  name = "${var.vpc_name}-ipv4-address"
}

resource "google_compute_subnetwork" "vpc_subnet" {
  count                    = length(var.subnets_names)
  name                     = "${var.subnets_names[count.index]}-subnet"
  ip_cidr_range            = var.subnets_cidr[count.index]
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  name    = "${var.vpc_name}-router"
  region  = google_compute_subnetwork.vpc_subnet[1].region
  network = google_compute_network.vpc_network.id

  bgp {
    asn = 64514
  }
  depends_on = [google_compute_network.vpc_network, google_compute_subnetwork.vpc_subnet]
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.vpc_name}-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = google_compute_subnetwork.vpc_subnet
    content {
      name                  = "${subnetwork.value.name}"
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }

  depends_on = [
    google_compute_router.router,
    google_compute_subnetwork.vpc_subnet[0],
    google_compute_subnetwork.vpc_subnet[1]
  ]
}