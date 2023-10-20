
module "network" {
  source                 = "./network"
  compartment_ocid       = var.compartment_ocid
  windmill_vcn_cidr      = var.windmill_vcn_cidr
  postgresql_subnet_cidr = var.postgresql_subnet_cidr
  windmill_subnet_cidr   = var.windmill_subnet_cidr
}


module "arch-windmill-postgresql" {
  source       = "github.com/paihari/terraform-oci-arch-postgresql"
  tenancy_ocid = var.tenancy_ocid
  #user_ocid                     = var.user_ocid
  #fingerprint                   = var.fingerprint
  #private_key_path              = var.private_key_path
  region                        = var.region
  availability_domain_name      = var.availability_domain
  compartment_ocid              = var.compartment_ocid
  use_existing_vcn              = true                              # You can inject your own VCN and subnet 
  create_in_private_subnet      = true                              # Subnet should be associated with NATGW and proper Route Table.
  windmill_vcn                  = module.network.windmill_vcn_id    # Injected VCN
  postgresql_subnet             = module.network.postgres_subnet_id # Injected Private Subnet
  postgresql_password           = var.postgresql_database_password
  postgresql_deploy_hotstandby1 = true # if we want to setup hotstandby1
  postgresql_deploy_hotstandby2 = true # if we want to setup hotstandby2
}

module "container_instances" {
  source           = "./container_instances"
  compartment_ocid = var.compartment_ocid
  subnet_id = module.network.windmill_subnet_id
  database_url = module.arch-windmill-postgresql.database_url
}




