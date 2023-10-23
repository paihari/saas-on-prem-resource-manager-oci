output "windmill_vcn_id" {
  value = oci_core_virtual_network.windmill_vcn.id
}

output "postgres_subnet_id" {
  value = oci_core_subnet.postgres_subnet.id
}

output "windmill_subnet_id" {
  value = oci_core_subnet.windmill_subnet.id
}