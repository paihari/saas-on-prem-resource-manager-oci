variable "compartment_ocid" {

}

variable "availability_domain" {
  default = "vWQc:EU-FRANKFURT-1-AD-1"

}

variable "subnet_id" {
  
}


variable "database_url" {
  
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

