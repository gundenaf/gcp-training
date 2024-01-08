# GCP CLI Usage

## Goal: The objective of these GCP CLI commands is to create and configure a simple infrastructure on Google Cloud Platform (GCP) using the command-line interface (CLI). This infrastructure includes a Virtual Private Cloud (VPC), a subnet, an instance template, a managed instance group, and the necessary components for setting up a basic HTTP load balancer.

## Tasks:

1. Initialize GCP:
Install Google Cloud SDK.

2. Define Load Balancer Parameters:
Specify type, protocols, ports, and region for the Load Balancer.

3. Create Load Balancer:
Use the gcloud compute backend-services command to create a Load Balancer.

4. Configure Managed Instance Group:
Form a Managed instance group with Google Compute Engine instances.

5. Create Target Pool:
Establish a target pool containing the instances for traffic routing.

6. Configure Instance Ranking:
Set up instance ranking and weights within the Managed instance group.

7. Create Routing Rules:
Define routing rules in Google Cloud Load Balancer to direct traffic to the target pool.