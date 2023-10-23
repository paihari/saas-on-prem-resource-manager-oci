output "Windmill_Server_Container_Instance_public_IP" {
  value = module.container_instances.Windmill_Server_Container_Instance_public_IP
}

output "Windmill_Default_Username_and_Passwoed" {
  value = "admin@windmill.dev/changeme"
}