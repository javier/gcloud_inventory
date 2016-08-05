#!/bin/bash
highlight_matching_line() { grep --color -E ".*$1.*|\$"; }
section() { echo "********************** $1 ****************************"; }

# all instances, filtering the RUNNING ones
section "COMPUTE INSTANCES"
gcloud compute instances list --format='csv(name, zone, machineType, status)' | highlight_matching_line RUNNING
# all ip addresses, filtering the RESERVED ones
section "PUBLIC IP ADDRESSES"
gcloud compute addresses list --format='table(name,region,address,status)' | highlight_matching_line RESERVED 
# all cloud sql instances, filtering the RUNNABLE 
section "SQL INSTANCES"
gcloud sql instances list --format='csv(instance, region, settings.tier, state)' | highlight_matching_line RUNNABLE
# XXX we should probably list the backups for each cloud sql instance, RUNNABLE or not
# gcloud sql backups list --instance XXX
# all disks, filtering every line (all will contain a - character) 
section "DISKS"
gcloud compute disks list --format='csv(name,zone,sizeGb,type)' | highlight_matching_line -
# all snapshots, filtering every line (all will contain a / character) 
section "DISK SNAPSHOTS"
gcloud compute snapshots list --format='csv(storageBytes, sourceDisk)' | highlight_matching_line /
# all custom images, filtering everything even headers as there is no common character to filter
section "COMPUTE ENGINE IMAGES"
gcloud compute images list  --no-standard-images --format='csv(name,family)' | highlight_matching_line .
#all gcloud storage buckets, filtering all
section "CLOUD STORAGE BUCKETS"
gsutil ls | highlight_matching_line gs
#all bigquery datasets filtering all
section "BIGQUERY DATASETS"
gcloud alpha bigquery datasets list --format='csv(datasetReference.datasetId)' | highlight_matching_line .
# XXX we should probably add every bigquery table here
