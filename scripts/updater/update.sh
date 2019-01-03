#!/usr/bin/env bash

# usage: 
#   export WIN_PASS=<yourpass>
#   ./update.sh 12.34.45.6 3472k8s000 

IP=$1
NODE=$2
KEY_FILE=${3:-"~/.ssh/id_rsa"}
SSH_USER=${4:-"adminuser"}
NEW_BINARIES=${5:-"k8s-binaries"}
PACKAGES=${6:-"k8s-packages"}

echo "zip files"
dt="$(date '+%m%d%Y-%H%M%S')"
pushd ~/
tar -cvzf "$PACKAGES/kubebinaries_$dt.tar.gz" $NEW_BINARIES
popd

echo "add script and files"
scp -i "$KEY_FILE" win-updater.ps1 "$SSH_USER@$IP:"
scp -i "$KEY_FILE" "~/$PACKAGES/kubebinaries_$dt.tar.gz" "$SSH_USER@$IP:"

echo "kick off update"
kubectl drain $NODE
ssh -t -i "$KEY_FILE" "$SSH_USER@$IP" "powershell -f win-updater.ps1 kubebinaries_$dt.tar.gz"
kubectl uncordon $NODE

echo "complete windows update"