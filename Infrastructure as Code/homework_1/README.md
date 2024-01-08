# Terraform GCP Infrastructure Setup

## Project Overview: This project sets up a Google Cloud Platform (GCP) infrastructure using Terraform. The infrastructure includes a Virtual Private Cloud (VPC), Firewall Rules, and a Compute Engine instance. Below is a step-by-step breakdown of the setup:

## Tasks:

1. Network Module Setup

We created a network module to set up the VPC and related networking components. This includes:

    A VPC with a specified CIDR block.
    Both public and private subnets within the VPC.
    Enabled Private Google Access for the VPC.

2. Security Module Setup

We created a security module to set up the firewall rules. This includes:

    A firewall rule associated with the VPC created in the network module.
    Ingress and egress rules for the firewall, allowing traffic from specified IP ranges.

3. Compute Module Setup

We created a compute module to set up a Compute Engine instance. This includes:

    A Compute Engine instance using the latest specified image.
    The instance is associated with the firewall rules created in the security module.
    The instance is launched within the public subnet of the VPC created in the network module.
    The instance has a specified disk size and type.

4. Root Module

In the root directory, we utilized these modules to create an infrastructure with specified values.

5. Providers Setup

We set up GCP as our provider in providers.tf. We specified the region, service account key, and other necessary credentials.

6. Destroying Infrastructure

After completing your work with the infrastructure, it's crucial to destroy it to avoid unnecessary costs. 