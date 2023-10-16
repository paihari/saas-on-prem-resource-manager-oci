# terraform-oci-fullstack-windmill

To run using terraform add below content in terraform.tfvars

```
# Authentication
tenancy_ocid         = "<tenancy_ocid>"
user_ocid            = "<user_ocid>"
fingerprint          = "<finger_print>"
private_key_path     = "<pem_private_key_path>"

# Region
region = "<oci_region>"

# availability Domain 
availability_domain_name = "<availability_domain_name>" # for example GrCH:US-ASHBURN-AD-1

# Compartment
compartment_ocid        = "<compartment_ocid>"

# PostgreSQL Password
postgresql_database_password     = "<postgresql_password>"


````
