variable "compartment_ocid" {

}


variable "windmill_vcn_cidr" {
  default = "10.1.0.0/16"
}


variable "postgresql_subnet_cidr" {
  default = "10.1.20.0/24"
}

variable "windmill_subnet_cidr" {
  default = "10.1.1.0/24"
}