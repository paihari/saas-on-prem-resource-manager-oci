output "Windmill_Server_Container_Instance_public_IP" {
  value = oci_container_instances_container_instance.windmill_server_instance.id
}



output "Windmill_Default_Username_and_Passwoed" {
  value = "admin@windmill.dev/changeme"
}