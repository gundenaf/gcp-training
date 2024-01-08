```bash
#----------------------------------------------------
# Google Cloud Authentication Login
#----------------------------------------------------

[slava@phobos ~]$ gcloud auth login
Your browser has been opened to visit:
You are now logged in as [********@gmail.com].
Your current project is [sixth-embassy-410011].  You can change this setting by running:
  $ gcloud config set project PROJECT_ID

#----------------------------------------------------
# Creating a Google Cloud Compute Disk
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute disks create my-gcp-disk --size=1GB --zone=us-west1-a
WARNING: You have selected a disk size of under [200GB]. This may result in poor I/O performance. For more information, see: https://developers.google.com/compute/docs/disks#performance.
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/zones/us-west1-a/disks/my-gcp-disk].
NAME         ZONE        SIZE_GB  TYPE         STATUS
my-gcp-disk  us-west1-a  1        pd-standard  READY

New disks are unformatted. You must format and mount a disk before it
can be used. You can find instructions on how to do this at:

https://cloud.google.com/compute/docs/disks/add-persistent-disk#formatting

#----------------------------------------------------
# Creating a Google Cloud Compute Instance
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute instances create my-instance \
    --machine-type=e2-micro \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --zone=us-west1-a
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/zones/us-west1-a/instances/my-instance].
NAME         ZONE        MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP   STATUS
my-instance  us-west1-a  e2-micro                   10.138.0.4   34.82.148.38  RUNNING

#----------------------------------------------------
# Attaching a Disk to a Google Cloud Compute Instance
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute instances attach-disk my-instance \
    --disk=my-gcp-disk \
    --zone=us-west1-a
Updated [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/zones/us-west1-a/instances/my-instance].

#----------------------------------------------------
# Creating a Google Cloud Storage Bucket
#----------------------------------------------------

[slava@phobos ~]$ gsutil mb -l us-east1 gs://gcp-mikhalenka-gcs
Creating gs://gcp-mikhalenka-gcs/...

#----------------------------------------------------
# Uploading files to Google Cloud Storage Bucket
#----------------------------------------------------

[slava@phobos ~]$ gsutil cp test1.txt gs://gcp-mikhalenka-gcs/
Copying file://test1.txt [Content-Type=text/plain]...
/ [1 files][    0.0 B/    0.0 B]                                                
Operation completed over 1 objects.                                              
[slava@phobos ~]$ gsutil cp test2.txt gs://gcp-mikhalenka-gcs/
Copying file://test2.txt [Content-Type=text/plain]...
/ [1 files][    0.0 B/    0.0 B]                                                
Operation completed over 1 objects.     

#----------------------------------------------------
# Creating a Google Cloud SQL Instance
#----------------------------------------------------

[slava@phobos ~]$ gcloud sql instances create gcp-mikhalenka-csql \
    --database-version=MYSQL_8_0 \
    --cpu=1 \
    --memory=3840MB \
    --region=us-west1 \
    --root-password=gcp-mikhalenka-password \
    --storage-type=HDD \
    --storage-size=10GB \
    --availability-type=zonal
Creating Cloud SQL instance for MYSQL_8_0...done.                                                                                                                     
Created [https://sqladmin.googleapis.com/sql/v1beta4/projects/sixth-embassy-410011/instances/gcp-mikhalenka-csql].
NAME                 DATABASE_VERSION  LOCATION    TIER              PRIMARY_ADDRESS  PRIVATE_ADDRESS  STATUS
gcp-mikhalenka-csql  MYSQL_8_0         us-west1-c  db-custom-1-3840  35.227.177.225   -                RUNNABLE    

#----------------------------------------------------
# Updating Google Cloud SQL Instance
#----------------------------------------------------

[slava@phobos ~]$ gcloud sql instances patch gcp-mikhalenka-csql --no-deletion-protection
The following message will be used for the patch API method.
{"name": "gcp-mikhalenka-csql", "project": "sixth-embassy-410011", "settings": {"deletionProtectionEnabled": false}}
Patching Cloud SQL instance...done.                                                                                                                                   
Updated [https://sqladmin.googleapis.com/sql/v1beta4/projects/sixth-embassy-410011/instances/gcp-mikhalenka-csql].

#----------------------------------------------------
# Creating a Backup for Google Cloud SQL Instance
#----------------------------------------------------

[slava@phobos ~]$ gcloud sql backups create --instance=gcp-mikhalenka-csql
Backing up Cloud SQL instance...done.                                                                                                                                 
[https://sqladmin.googleapis.com/sql/v1beta4/projects/sixth-embassy-410011/instances/gcp-mikhalenka-csql] backed up.

#----------------------------------------------------
# Listing Backups for Google Cloud SQL Instance
#----------------------------------------------------

[slava@phobos ~]$ gcloud sql backups list --instance=gcp-mikhalenka-csql
ID             WINDOW_START_TIME              ERROR  STATUS      INSTANCE
1704205038132  2024-01-02T14:17:18.132+00:00  -      SUCCESSFUL  gcp-mikhalenka-csql

#----------------------------------------------------
# Restoring a Google Cloud SQL Instance from Backup
#----------------------------------------------------

[slava@phobos ~]$ gcloud sql backups restore 1704205038132 --restore-instance=gcp-mikhalenka-csql
All current data on the instance will be lost when the backup is restored.

Do you want to continue (Y/n)?  Y

Restoring Cloud SQL instance...done.                                                                                                                                  
Restored [https://sqladmin.googleapis.com/sql/v1beta4/projects/sixth-embassy-410011/instances/gcp-mikhalenka-csql].

#----------------------------------------------------
# Deleting a Google Cloud Compute Instance
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute instances delete my-instance --project=sixth-embassy-410011 --zone=us-west1-a
The following instances will be deleted. Any attached disks configured to be auto-deleted will be deleted unless they are attached to any other instances or the 
`--keep-disks` flag is given and specifies them for keeping. Deleting a disk is irreversible and any data on the disk will be lost.
 - [my-instance] in [us-west1-a]

Do you want to continue (Y/n)?  Y

Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/zones/us-west1-a/instances/my-instance].

#----------------------------------------------------
# Deleting a Google Cloud Compute Disk
#----------------------------------------------------

[slava@phobos ~]$ gcloud compute disks delete my-gcp-disk --zone=us-west1-a
The following disks will be deleted:
 - [my-gcp-disk] in [us-west1-a]

Do you want to continue (Y/n)?  Y

Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/zones/us-west1-a/disks/my-gcp-disk].

#----------------------------------------------------
# Deleting a Google Cloud SQL Backup
#----------------------------------------------------

[slava@phobos ~]$ gcloud sql backups delete 1704205038132 --instance=gcp-mikhalenka-csql
The backup will be deleted. You cannot undo this action.

Do you want to continue (Y/n)?  Y

Deleting backup run...done.                                                                                                                                           
Deleted backup run [1704205038132].

#----------------------------------------------------
# Deleting a Google Cloud SQL Instance
#----------------------------------------------------

[slava@phobos ~]$ gcloud sql instances delete gcp-mikhalenka-csql
All of the instance data will be lost when the instance is deleted.

Do you want to continue (Y/n)?  Y

Deleting Cloud SQL instance...done.                                                                                                                                   
Deleted [https://sqladmin.googleapis.com/sql/v1beta4/projects/sixth-embassy-410011/instances/gcp-mikhalenka-csql].

#----------------------------------------------------
# Deleting Google Cloud Storage Bucket and Contents
#----------------------------------------------------

[slava@phobos ~]$ gsutil rm -r gs://gcp-mikhalenka-gcs
Removing gs://gcp-mikhalenka-gcs/test1.txt#1704203216621458...
Removing gs://gcp-mikhalenka-gcs/test2.txt#1704203222318485...                  
/ [2 objects]                                                                   
Operation completed over 2 objects.                                              
Removing gs://gcp-mikhalenka-gcs/...
```