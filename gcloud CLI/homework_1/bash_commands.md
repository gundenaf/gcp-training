```bash
[slava@phobos ~]$ gcloud init
Welcome! This command will take you through the configuration of gcloud.

Your current configuration has been set to: [default]

You can skip diagnostics next time by using the following flag:
  gcloud init --skip-diagnostics

Network diagnostic detects and fixes local network connection issues.
Checking network connection...done.                                                                                                                                   
Reachability Check passed.
Network diagnostic passed (1/1 checks passed).

You must log in to continue. Would you like to log in (Y/n)?  Y

Your browser has been opened to visit:


You are logged in as: [********@gmail.com].

Pick cloud project to use: 
 [1] bold-upgrade-388220
 [2] sixth-embassy-410011
 [3] Enter a project ID
 [4] Create a new project
Please enter numeric choice or text value (must exactly match list item):  3

Enter project ID you would like to use:  sixth-embassy-410011
Your current project has been set to: [sixth-embassy-410011].

Do you want to configure a default Compute Region and Zone? (Y/n)?  Y

Which Google Compute Engine zone would you like to use as project default?
If you do not specify a zone via a command line flag while working with Compute Engine resources, the default is assumed.
Please enter numeric choice or text value (must exactly match list item):  us-west1-a 

Your project default Compute Engine zone has been set to [us-west1-a].
You can change it by running [gcloud config set compute/zone NAME].

Your project default Compute Engine region has been set to [us-west1].
You can change it by running [gcloud config set compute/region NAME].

Created a default .boto configuration file at [/home/slava/.boto]. See this file and
[https://cloud.google.com/storage/docs/gsutil/commands/config] for more
information about configuring Google Cloud Storage.
Your Google Cloud SDK is configured and ready to use!

* Commands that require authentication will use *********@gmail.com by default
* Commands will reference project `sixth-embassy-410011` by default
* Compute Engine commands will use region `us-west1` by default
* Compute Engine commands will use zone `us-west1-a` by default

Run `gcloud help config` to learn how to change individual settings

This gcloud configuration is called [default]. You can create additional configurations if you work with multiple accounts and/or projects.
Run `gcloud topic configurations` to learn more.

Some things to try next:

* Run `gcloud --help` to see the Cloud Platform services you can interact with. And run `gcloud help COMMAND` to get help on any gcloud command.
* Run `gcloud topic --help` to learn about advanced features of the SDK like arg files and output formatting
* Run `gcloud cheat-sheet` to see a roster of go-to `gcloud` commands.
[slava@phobos ~]$ gcloud compute instances create homework-1-sdk \
  --project=sixth-embassy-410011 \
  --zone=us-west1-a \
  --machine-type=e2-micro \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=10
WARNING: You have selected a disk size of under [200GB]. This may result in poor I/O performance. For more information, see: https://developers.google.com/compute/docs/disks#performance.
Created [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/zones/us-west1-a/instances/homework-1-sdk].
NAME            ZONE        MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP     STATUS
homework-1-sdk  us-west1-a  e2-micro                   10.138.0.3   35.227.153.100  RUNNING
[slava@phobos ~]$ gcloud compute instances delete homework-1-sdk --project=sixth-embassy-410011 --zone=us-west1-a
The following instances will be deleted. Any attached disks configured to be auto-deleted will be deleted unless they are attached to any other instances or the 
`--keep-disks` flag is given and specifies them for keeping. Deleting a disk is irreversible and any data on the disk will be lost.
 - [homework-1-sdk] in [us-west1-a]

Do you want to continue (Y/n)?  Y

Deleted [https://www.googleapis.com/compute/v1/projects/sixth-embassy-410011/zones/us-west1-a/instances/homework-1-sdk].
```