```bash
#----------------------------------------------------
# Google Cloud Authentication Login
#----------------------------------------------------

[slava@phobos ~]$ gcloud auth login
Your browser has been opened to visit:

You are now logged in as [*********@gmail.com].
Your current project is [sixth-embassy-410011].  You can change this setting by running:
  $ gcloud config set project PROJECT_ID

#----------------------------------------------------
# Create Virtual Private Cloud (VPC)
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute networks create gcp-mikhalenka-network --subnet-mode=custom
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/networks/gcp-mikhalenka-network].
NAME                    SUBNET_MODE  BGP_ROUTING_MODE  IPV4_RANGE  GATEWAY_IPV4
gcp-mikhalenka-network  CUSTOM       REGIONAL

Instances on this network will not be reachable until firewall rules
are created. As an example, you can allow all internal traffic between
instances as well as SSH, RDP, and ICMP by running:

$ gcloud compute firewall-rules create <FIREWALL_NAME> --network gcp-mikhalenka-network --allow tcp,udp,icmp --source-ranges <IP_RANGE>
$ gcloud compute firewall-rules create <FIREWALL_NAME> --network gcp-mikhalenka-network --allow tcp:22,tcp:3389,icmp

#----------------------------------------------------
# Create Subnet
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute networks subnets create gcp-mikhalenka-subnet-1 \
    --network=gcp-mikhalenka-network \
    --range=10.0.1.0/24 \
    --region=us-west1
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/regions/us-west1/subnetworks/gcp-mikhalenka-subnet-1].
NAME                     REGION    NETWORK                 RANGE        STACK_TYPE  IPV6_ACCESS_TYPE  INTERNAL_IPV6_PREFIX  EXTERNAL_IPV6_PREFIX
gcp-mikhalenka-subnet-1  us-west1  gcp-mikhalenka-network  10.0.1.0/24  IPV4_ONLY

#----------------------------------------------------
# Create Instance Template
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute instance-templates create gcp-mikhalenka-instance-template \
    --machine-type=e2-micro \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --subnet=gcp-mikhalenka-subnet-1
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/instanceTemplates/gcp-mikhalenka-instance-template].
NAME                              MACHINE_TYPE  PREEMPTIBLE  CREATION_TIMESTAMP
gcp-mikhalenka-instance-template  e2-micro                   2024-01-03T03:14:07.361-08:00

#----------------------------------------------------
# Create Instance Group
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute instance-groups managed create gcp-mikhalenka-instance-group \
    --base-instance-name=gcp-mikhalenka-instance \
    --size=2 \
    --template=gcp-mikhalenka-instance-template \
    --zone=us-west1-a
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/zones/us-west1-a/instanceGroupManagers/gcp-mikhalenka-instance-group].
NAME                           LOCATION    SCOPE  BASE_INSTANCE_NAME       SIZE  TARGET_SIZE  INSTANCE_TEMPLATE                 AUTOSCALED
gcp-mikhalenka-instance-group  us-west1-a  zone   gcp-mikhalenka-instance  0     2            gcp-mikhalenka-instance-template  no

#----------------------------------------------------
# Set named ports for the managed instance group
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute instance-groups managed set-named-ports gcp-mikhalenka-instance-group \
    --named-ports http:80 \
    --zone=us-west1-a
Updated [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/zones/us-west1-a/instanceGroups/gcp-mikhalenka-instance-group].

#----------------------------------------------------
# Create an HTTP health check
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute http-health-checks create gcp-mikhalenka-http-health-check
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/httpHealthChecks/gcp-mikhalenka-http-health-check].
NAME                              HOST  PORT  REQUEST_PATH
gcp-mikhalenka-http-health-check        80    /

#----------------------------------------------------
# Create an HTTP backend service
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute backend-services create gcp-mikhalenka-backend-service \
    --protocol=HTTP \
    --http-health-checks=gcp-mikhalenka-http-health-check \
    --global
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/backendServices/gcp-mikhalenka-backend-service].
NAME                            BACKENDS  PROTOCOL
gcp-mikhalenka-backend-service            HTTP

#----------------------------------------------------
# Add the managed instance group as a backend to the backend service
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute backend-services add-backend gcp-mikhalenka-backend-service \
    --instance-group=gcp-mikhalenka-instance-group \
    --instance-group-zone=us-west1-a \
    --global
Updated [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/backendServices/gcp-mikhalenka-backend-service].

#----------------------------------------------------
# Create a URL card with backend service
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute url-maps create gcp-mikhalenka-url-map --default-service=gcp-mikhalenka-backend-service
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/urlMaps/gcp-mikhalenka-url-map].
NAME                    DEFAULT_SERVICE
gcp-mikhalenka-url-map  backendServices/gcp-mikhalenka-backend-service

#----------------------------------------------------
# Create Target HTTP Proxy
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute target-http-proxies create gcp-mikhalenka-target-proxy \
    --url-map=gcp-mikhalenka-url-map
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/targetHttpProxies/gcp-mikhalenka-target-proxy].
NAME                         URL_MAP
gcp-mikhalenka-target-proxy  gcp-mikhalenka-url-map

#----------------------------------------------------
# Create Global Forwarding Rule
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute forwarding-rules create gcp-mikhalenka-forwarding-rule \
    --global \
    --target-http-proxy=gcp-mikhalenka-target-proxy \
    --ports=80
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/forwardingRules/gcp-mikhalenka-forwarding-rule].

#----------------------------------------------------
# Create Global IP Address for Load Balancer
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute addresses create gcp-mikhalenka-ip-address --global
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/addresses/gcp-mikhalenka-ip-address].

#----------------------------------------------------
# Create a global forwarding rule for HTTP traffic
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute forwarding-rules create gcp-mikhalenka-forwarding-rule \
    --global \
    --ip-version=IPV4 \
    --target-http-proxy=gcp-mikhalenka-target-proxy \
    --ports=80
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/forwardingRules/gcp-mikhalenka-forwarding-rule].

#----------------------------------------------------
# Deleting Global Forwarding Rule
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute forwarding-rules delete gcp-mikhalenka-forwarding-rule --global
The following global forwarding rules will be deleted:
 - [gcp-mikhalenka-forwarding-rule]

Do you want to continue (Y/n)?  Y

Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/forwardingRules/gcp-mikhalenka-forwarding-rule].

#----------------------------------------------------
# Deleting Global IP Address for Load Balancer
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute addresses delete gcp-mikhalenka-ip-address --global
The following global addresses will be deleted:
 - [gcp-mikhalenka-ip-address]

Do you want to continue (Y/n)?  Y

Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/addresses/gcp-mikhalenka-ip-address].

#----------------------------------------------------
# Deleting Target HTTP Proxy
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute target-http-proxies delete gcp-mikhalenka-target-proxy
The following target http proxies will be deleted:
 - [gcp-mikhalenka-target-proxy]

Do you want to continue (Y/n)?  Y

Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/targetHttpProxies/gcp-mikhalenka-target-proxy].

#----------------------------------------------------
# Deleting URL Map
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute url-maps delete gcp-mikhalenka-url-map
The following url maps will be deleted:
 - [gcp-mikhalenka-url-map]

Do you want to continue (Y/n)?  Y

Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/urlMaps/gcp-mikhalenka-url-map].

#----------------------------------------------------
# Deleting Backend Service
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute backend-services delete gcp-mikhalenka-backend-service --global
The following backend services will be deleted:
 - [gcp-mikhalenka-backend-service]

Do you want to continue (Y/n)?  Y

Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/backendServices/gcp-mikhalenka-backend-service].

#----------------------------------------------------
# Deleting HTTP Health Check
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute http-health-checks delete gcp-mikhalenka-http-health-check
The following http health checks will be deleted:
 - [gcp-mikhalenka-http-health-check]

Do you want to continue (Y/n)?  Y

Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/httpHealthChecks/gcp-mikhalenka-http-health-check].


#----------------------------------------------------
# Deleting Instance Group
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute instance-groups managed delete gcp-mikhalenka-instance-group --zone=us-west1-a
The following instance group managers will be deleted:
 - [gcp-mikhalenka-instance-group] in [us-west1-a]

Do you want to continue (Y/n)?  Y

Deleting Managed Instance Group...⠹Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/zones/us-west1-a/instanceGroupManagers/gcp-mikhalenka-instance-group].
Deleting Managed Instance Group...done.        

#----------------------------------------------------
# Deleting Instance Template
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute instance-templates delete gcp-mikhalenka-instance-template
The following instance templates will be deleted:
 - [gcp-mikhalenka-instance-template]

Do you want to continue (Y/n)?  Y

Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/instanceTemplates/gcp-mikhalenka-instance-template].

#----------------------------------------------------
# Deleting Subnet
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute networks subnets delete gcp-mikhalenka-subnet-1 --region=us-west1
The following subnetworks will be deleted:
 - [gcp-mikhalenka-subnet-1] in [us-west1]

Do you want to continue (Y/n)?  Y

Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/regions/us-west1/subnetworks/gcp-mikhalenka-subnet-1].

#----------------------------------------------------
# Deleting VPC (Virtual Private Cloud)
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute networks delete gcp-mikhalenka-network
The following networks will be deleted:
 - [gcp-mikhalenka-network]

Do you want to continue (Y/n)?  Y

Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/global/networks/gcp-mikhalenka-network].
```