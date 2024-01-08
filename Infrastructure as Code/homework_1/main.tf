module "network" {
  source                          = "./modules/network"
  vpc_name                        = "gcp-mikhalenka"
  subnets_names                   = ["gcp-mikhalenka-1", "gcp-mikhalenka-2"]
  subnets_cidr                    = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "security" {
  source                          = "./modules/security"
  sg_name                         = "gcp-mikhalenka-sg"
  network_name                    = module.network.vpc_network_name
  ingress_ports                   = [22]
  source_ip_range                 = "0.0.0.0/0"
}

module "compute" {
  source                          = "./modules/compute"
  machine_type                    = "e2-micro"
  zone_name                       = "us-west1-a"
  disk_image                      = "ubuntu-os-cloud/ubuntu-2204-lts"
  vm_name                         = "gcp-mikhalenka-instance"
  ssh_username                    = "slava"
  ssh_public_key                  = "/home/slava/.ssh/id_ed25519.pub"
  disk_size                       = 15
  network_name                    = module.network.vpc_network_name
  subnet_name                     = module.network.subnets_names[1]
  static_ipv4_address             = module.network.static_ip_address

  depends_on = [module.network]
}