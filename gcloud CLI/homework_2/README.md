# GCP CLI Usage

## Tasks:

- Create Persistent Disk:
        Use gcloud compute disks create to create a Persistent Disk.

- Create VM Instance and Attach the Disk:
        Use gcloud compute instances create to create a VM instance.
        Attach the previously created disk to the VM instance using gcloud compute instances attach-disk.

- Create Cloud Storage Bucket and Upload Files:
        Use gsutil mb to create a Cloud Storage bucket.
        Upload random files to the bucket using gsutil cp.

- Create Cloud SQL Instance and Configure Access:
        Use gcloud sql instances create to create a Cloud SQL instance.
        Configure access using gcloud sql users create.

- Create a Snapshot for Cloud SQL Instance:
        Use gcloud sql backups create to create a backup snapshot for the Cloud SQL instance.

- Restore Cloud SQL Instance from Snapshot:
        Use gcloud sql backups restore to restore the Cloud SQL instance from the created snapshot.

- Clean All Resources:
        Use appropriate gcloud commands to delete the created resources (VM instance, disk, Cloud Storage bucket, Cloud SQL instance, etc.).