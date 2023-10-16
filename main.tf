resource "oci_core_virtual_network" "windmill_vcn" {

  cidr_block     = var.windmill_vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "WindmillVCN"
  dns_label      = "windmillvcn"

}

resource "oci_core_nat_gateway" "postgres_nat" {
  compartment_id = var.compartment_ocid
  display_name   = "PostgresNAT"
  vcn_id         = oci_core_virtual_network.windmill_vcn.id
}

resource "oci_core_route_table" "postgres_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.windmill_vcn.id
  display_name   = "PostgresRT"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.postgres_nat.id
  }
}

resource "oci_core_security_list" "postgres_securitylist" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.windmill_vcn.id
  display_name   = "postgresSecurityList"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "5432"
      min = "5432"
    }
  }
}

resource "oci_core_subnet" "postgres_subnet" {
  cidr_block                 = var.postgresql_subnet_cidr
  display_name               = "PostGreSubnet"
  dns_label                  = "postgresubnet"
  security_list_ids          = [oci_core_security_list.postgres_securitylist.id]
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.windmill_vcn.id
  route_table_id             = oci_core_route_table.postgres_rt.id
  dhcp_options_id            = oci_core_virtual_network.windmill_vcn.default_dhcp_options_id
  prohibit_public_ip_on_vnic = true
}


resource "oci_core_internet_gateway" "windmill_igw" {
  compartment_id = var.compartment_ocid
  display_name   = "WindmillIGW"
  vcn_id         = oci_core_virtual_network.windmill_vcn.id

}

resource "oci_core_route_table" "windmill_rt" {

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.windmill_vcn.id
  display_name   = "WindmillRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.windmill_igw.id
  }

}
resource "oci_core_security_list" "windmill_securitylist" {

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.windmill_vcn.id
  display_name   = "WindmillSecurityList"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "8000"
      min = "8000"
    }
  }
}


resource "oci_core_subnet" "windmill_subnet" {
  cidr_block                 = var.windmill_subnet_cidr
  display_name               = "WindmillSubnet"
  dns_label                  = "windmillsubnet"
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_virtual_network.windmill_vcn.id
  route_table_id             = oci_core_route_table.windmill_rt.id
  security_list_ids          = [oci_core_security_list.windmill_securitylist.id]
  prohibit_public_ip_on_vnic = false

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
  use_existing_vcn              = true                                     # You can inject your own VCN and subnet 
  create_in_private_subnet      = true                                     # Subnet should be associated with NATGW and proper Route Table.
  windmill_vcn                  = oci_core_virtual_network.windmill_vcn.id # Injected VCN
  postgresql_subnet             = oci_core_subnet.postgres_subnet.id       # Injected Private Subnet
  postgresql_password           = var.postgresql_database_password
  postgresql_deploy_hotstandby1 = true # if we want to setup hotstandby1
  postgresql_deploy_hotstandby2 = true # if we want to setup hotstandby2
}


resource "oci_container_instances_container_instance" "windmill_server_instance" {
  compartment_id                       = var.compartment_ocid
  availability_domain                  = var.availability_domain
  display_name                         = "WindmillServer"
  container_restart_policy             = var.container_restart_policy
  graceful_shutdown_timeout_in_seconds = var.graceful_shutdown_timeout_in_seconds
  state                                = var.state


  shape = var.shape
  shape_config {
    memory_in_gbs = var.shape_config.memory_in_gbs
    ocpus         = var.shape_config.ocpus
  }

  containers {
    display_name = "container-1-windmill-server"
    environment_variables = {
      "DATABASE_URL"   = module.arch-windmill-postgresql.database_url
      "RUST_LOG"       = "INFO"
      "NUM_WORKERS"    = "0"
      "DISABLE_SERVER" = "false"
      "METRICS_ADDR"   = "false"
    }
    image_url                      = "ghcr.io/windmill-labs/windmill"
    is_resource_principal_disabled = "false"
  }

  vnics {

    is_public_ip_assigned  = "true"
    skip_source_dest_check = "true"
    subnet_id              = oci_core_subnet.windmill_subnet.id
  }
}

resource "oci_container_instances_container_instance" "windmill_worker_instance_1" {
  compartment_id                       = var.compartment_ocid
  availability_domain                  = var.availability_domain
  display_name                         = "WindmillWorker-1"
  container_restart_policy             = var.container_restart_policy
  graceful_shutdown_timeout_in_seconds = var.graceful_shutdown_timeout_in_seconds
  state                                = var.state

  shape = var.shape
  shape_config {
    memory_in_gbs = var.shape_config.memory_in_gbs
    ocpus         = var.shape_config.ocpus
  }

  containers {
    display_name = "container-1-windmill-worker-1"
    environment_variables = {
      "DATABASE_URL"   = module.arch-windmill-postgresql.database_url
      "RUST_LOG"       = "INFO"
      "DISABLE_SERVER" = "true"
      "KEEP_JOB_DIR"   = "false"
      "METRICS_ADDR"   = "false"
      "WORKER_GROUP"   = "default"
    }
    image_url                      = "ghcr.io/windmill-labs/windmill"
    is_resource_principal_disabled = "false"
  }

  vnics {

    is_public_ip_assigned  = "true"
    skip_source_dest_check = "true"
    subnet_id              = oci_core_subnet.windmill_subnet.id
  }
}

resource "oci_container_instances_container_instance" "windmill_worker_instance_2" {
  compartment_id                       = var.compartment_ocid
  availability_domain                  = var.availability_domain
  display_name                         = "WindmillWorker-2"
  container_restart_policy             = var.container_restart_policy
  graceful_shutdown_timeout_in_seconds = var.graceful_shutdown_timeout_in_seconds
  state                                = var.state

  shape = var.shape
  shape_config {
    memory_in_gbs = var.shape_config.memory_in_gbs
    ocpus         = var.shape_config.ocpus
  }

  containers {
    display_name = "container-1-windmill-worker-2"
    environment_variables = {
      "DATABASE_URL"   = module.arch-windmill-postgresql.database_url
      "RUST_LOG"       = "INFO"
      "DISABLE_SERVER" = "true"
      "KEEP_JOB_DIR"   = "false"
      "METRICS_ADDR"   = "false"
      "WORKER_GROUP"   = "default"
    }
    image_url                      = "ghcr.io/windmill-labs/windmill"
    is_resource_principal_disabled = "false"
  }

  vnics {

    is_public_ip_assigned  = "true"
    skip_source_dest_check = "true"
    subnet_id              = oci_core_subnet.windmill_subnet.id
  }
}

resource "oci_container_instances_container_instance" "windmill_worker_native_instance_1" {
  compartment_id                       = var.compartment_ocid
  availability_domain                  = var.availability_domain
  display_name                         = "Windmill-Native-Worker-1"
  container_restart_policy             = var.container_restart_policy
  graceful_shutdown_timeout_in_seconds = var.graceful_shutdown_timeout_in_seconds
  state                                = var.state

  shape = var.shape
  shape_config {
    memory_in_gbs = var.shape_config.memory_in_gbs
    ocpus         = var.shape_config.ocpus
  }

  containers {
    display_name = "container-1-windmill-native-worker-1"
    environment_variables = {

      "DATABASE_URL"   = module.arch-windmill-postgresql.database_url
      "RUST_LOG"       = "INFO"
      "DISABLE_SERVER" = "true"
      "KEEP_JOB_DIR"   = "false"
      "METRICS_ADDR"   = "false"
      "WORKER_GROUP"   = "default"
    }
    image_url                      = "ghcr.io/windmill-labs/windmill"
    is_resource_principal_disabled = "false"
  }

  vnics {

    is_public_ip_assigned  = "true"
    skip_source_dest_check = "true"
    subnet_id              = oci_core_subnet.windmill_subnet.id
  }
}


resource "oci_container_instances_container_instance" "docker_dpage_pgadmin" {
  compartment_id                       = var.compartment_ocid
  availability_domain                  = var.availability_domain
  display_name                         = "PGADMIN"
  container_restart_policy             = var.container_restart_policy
  graceful_shutdown_timeout_in_seconds = var.graceful_shutdown_timeout_in_seconds
  state                                = var.state

  shape = var.shape
  shape_config {
    memory_in_gbs = var.shape_config.memory_in_gbs
    ocpus         = var.shape_config.ocpus
  }

  containers {
    display_name = "container-1-pgadmin"
    environment_variables = {
      "PGADMIN_DEFAULT_EMAIL"    = "hariprasad.bantwal@avaloq.com"
      "PGADMIN_DEFAULT_PASSWORD" = "changeme"
    }
    image_url                      = "docker.io/dpage/pgadmin4"
    is_resource_principal_disabled = "false"
  }

  vnics {

    is_public_ip_assigned  = "true"
    skip_source_dest_check = "true"
    subnet_id              = oci_core_subnet.windmill_subnet.id
  }
}




