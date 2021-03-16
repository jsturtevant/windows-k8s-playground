#!/bin/bash

set -o errexit
set -o pipefail

# Docs for gsutil https://cloud.google.com/storage/docs/gsutil/commands/cat?hl=vi
# view files in a bucket
#$gsutil ls gs://kubernetes-jenkins/logs/ci-kubernetes-e2e-aks-engine-azure-1-18-windows-serial-slow/1315329169306947584
#
# view all test runs in a job
#gsutil ls gs://kubernetes-jenkins/logs/ci-kubernetes-e2e-aks-engine-azure-1-18-windows-serial-slow/  

LOGS_FOLDER="$HOME/k8s-logs"

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -j | --job-to-collect )
    #example: ci-kubernetes-e2e-aks-engine-azure-1-18-windows-serial-slow/1315329169306947584
    shift; JOB_TO_COLLECT=$1
    ;;
  -l | --logs-folder )
    shift; LOGS_FOLDER=$1
    ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi

: "${JOB_TO_COLLECT:?Please provide an a job name in format \"job-name/instance-id\" by pass parrameters -j.}"

# copy files down for a job 
mkdir -p $LOGS_FOLDER/$JOB_TO_COLLECT
gsutil -m cp -r "gs://kubernetes-jenkins/logs/${JOB_TO_COLLECT}/*" $LOGS_FOLDER/$JOB_TO_COLLECT

# Unzip files: https://stackoverflow.com/a/2318189
find $LOGS_FOLDER/$JOB_TO_COLLECT -name "*.zip" | xargs -P 5 -I fileName sh -c 'unzip -o -d "$(dirname "fileName")/$(basename -s .zip "fileName")" "fileName"'