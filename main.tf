terraform {
  backend "s3" {
    bucket                      = "passbolt"
    key                         = "terraform.tfstate"
    region                      = "us-east-1"
    skip_credentials_validation = true
    endpoint                    = "https://s3.cloud.mts.ru"
    force_path_style            = "true"
  }
}

provider "vcd" {
  version              = "~> 2.9.0"
  user                 = var.vcd_user
  password             = var.vcd_pass
  auth_type            = "integrated"
  org                  = var.vcd_org
  vdc                  = var.vcd_vdc
  url                  = var.vcd_url
  allow_unverified_ssl = var.vcd_allow_unverified_ssl
}

data "template_file" "docker" {
  template = "${file("${path.module}/install-docker.sh")}"
}

resource "vcd_vapp" "create_vapp" {
  name = "passbolt"
}

resource "vcd_vapp_org_network" "passbolt_network" {
  vapp_name        = "passbolt"
  org_network_name = "manage-net"
}

resource "vcd_vapp_vm" "vm_with_docker" {
  vapp_name     = "passbolt"
  name          = var.vm_name
  catalog_name  = "Linux"
  template_name = "CentOS-8.0.1905-x86_64-Server-Eng"
  memory        = 4096
  cpus          = 1
  cpu_cores     = 1
  guest_properties = {
    "guest.hostname" = var.vm_name,
  }
  storage_profile = "SSD"
  network {
    type               = "org"
    name               = vcd_vapp_org_network.passbolt_network.org_network_name
    ip_allocation_mode = "POOL"
    is_primary         = true
  }
  customization {
    initscript = data.template_file.docker.rendered
  }
  depends_on = [
    vcd_vapp.create_vapp,
  ]
}
