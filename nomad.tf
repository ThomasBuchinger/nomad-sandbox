

module "ex1" {
  source = "./modules/ex1_nginx"
}
module "ex2" {
  source = "./modules/ex2_ingress"
}
# module "ex3" {
#   source = "./modules/ex3_vm"
# }

terraform {
  required_providers {
    nomad = {
      source = "hashicorp/nomad"
      version = "1.4.19"
    }
  }
}

provider "nomad" {
  address = "http://168.119.179.42:4646/"
}



