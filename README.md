#### CSYE 6225 : Network Structure and Cloud Computing

##### Omkumar Dhirenbhai Solanki - 002841552

####Steps

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

project_id = "Enter your iroject ID"
region = "Enter region"
vpc_name = ["enter name", "enter name"] # List of Strings
webapp_subnet_name = "Enter name"
webapp_subnet_region = "Enter Region"
webapp_subnet_cidr = "Enter cidr"
db_subnet_name = "Enter name"
db_subnet_region = "Enter region"
db_subnet_cidr = "enter cidr"
