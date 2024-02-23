#### CSYE 6225 : Network Structure and Cloud Computing

##### Omkumar Dhirenbhai Solanki - 002841552

#### Steps

-   Create a new project in GCP
-   Method 1
-   After Creating a project click on IAM & Admin > Service Accounts > Create Service Account > Add Name > Create and Continue > Select Role > Basic - Editor > Continue > Done
-   Open Service Account > Go to keys > Create a key > JSON

-   Method 2
-   Install Gcloud CLI > gcloud auth application-default login > if requireed gcloud auth login

-   Enable Compute Engine API (https://console.cloud.google.com/marketplace/product/google/compute.googleapis.com)

-   Create a Folder
-   terraform init > To initialize a working directory with terraform configuration files
-   terraform plan > Show us a plan with the changes
-   terraform apply > applies the plan created by terraform plan
-   terraform destroy > delete the things created

-   If you get errors that the things are already created import them
-   terraform import google_compute_network.vpc projects/"project-id"/global/networks/"vpc-name"
-   terraform import google_compute_subnetwork.webapp_subnet projects/"project-id"/regions/us-east1/subnetworks/"subnet-name"
-   terraform import google_compute_route.webapp_subnet_route projects/"project-id"/global/routes/"route-name"

#### terraform variables

-   project_id =
-   region =
-   vpc_name =
-   webapp_subnet_name =
-   webapp_subnet_region =
-   webapp_subnet_cidr =
-   db_subnet_name =
-   db_subnet_region =
-   db_subnet_cidr =
-   vm_name =
-   machine_type =
-   zone =
-   boot_disk_image =
-   boot_disk_type =
-   tags = # list(string)
-   boot_disk_size =
-   network_tier =
-   stack_type =
-   auto_create_subnetworks =
-   routing_mode =
-   delete_default_routes_on_create =
-   webapp_subnet_route_dest_range =
-   webapp_subnet_route_next_hop_gateway =
-   webapp_firewall_name =
-   webapp_firewall_protocol =
-   webapp_firewall_ports = # list(string)
-   webapp-firewall_direction =
-   webapp_firewall_target_tags = # list(string)
-   webapp_firewall_source_ranges = # list(string)

-   Terraform init
-   Terraform plan
