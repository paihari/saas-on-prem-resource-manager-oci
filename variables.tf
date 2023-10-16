
variable "tenancy_ocid" {

}

variable "user_ocid" {

}

variable "fingerprint" {

}

variable "private_key_path" {

}

variable "region" {

}



variable "compartment_ocid" {

}

variable "availability_domain" {
  default = "vWQc:EU-FRANKFURT-1-AD-1"

}

variable "windmill_vcn_cidr" {
  default = "10.1.0.0/16"
}

variable "postgresql_subnet_cidr" {
  default = "10.1.20.0/24"
}

variable "postgresql_database_password" {

}


variable "windmill_subnet_cidr" {
  default = "10.1.1.0/24"
}


variable "container_restart_policy" {
  description = "(Optional) Container restart policy"
  type        = string
  default     = "ALWAYS"
}


variable "graceful_shutdown_timeout_in_seconds" {
  description = "(Optional) The amount of time that processes in a container have to gracefully end when the container must be stopped. For example, when you delete a container instance. After the timeout is reached, the processes are sent a signal to be deleted."
  type        = string
  default     = "0"
}


variable "state" {
  description = "(Optional) (Updatable) The target state for the Container Instance. Could be set to ACTIVE or INACTIVE."
  type        = string
  default     = "ACTIVE"
}

variable "shape" {
  description = "(Required) The shape of the container instance. The shape determines the resources available to the container instance."
  type        = string
  default     = "CI.Standard.E4.Flex"
}

variable "shape_config" {
  description = "(Required) The size and amount of resources available to the container instance."
  type = object({
    memory_in_gbs = number
    ocpus         = number
  })
  default = {
    memory_in_gbs = 1
    ocpus         = 1
  }
}

# variable "database_url" {
#     description = "DB URL of the Postgres to connect to Windmill."
#     type = string
# }


