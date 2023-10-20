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
      "DATABASE_URL"   = var.database_url
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
    subnet_id              = var.subnet_id
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
      "DATABASE_URL"   = var.database_url
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
    subnet_id              = var.subnet_id
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
      "DATABASE_URL"   = var.database_url
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
    subnet_id              = var.subnet_id
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

      "DATABASE_URL"   = var.database_url
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
    subnet_id              = var.subnet_id
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
    subnet_id              = var.subnet_id
  }
}
