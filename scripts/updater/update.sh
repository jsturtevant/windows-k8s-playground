#!/usr/bin/env bash

# usage: 
#   export WIN_PASS=<yourpass>
#   ./update.sh 12.34.45.6   

MASTERIP=$1
KEY_FILE=${2:-"~/.ssh/id_rsa"}
SSH_USER=${3:-"adminuser"}
NEW_BINARIES=${4:-"k8s-binaries"}
PACKAGES=${4:-"k8s-packages"}

echo "zip files"
dt="$(date '+%m%d%Y-%H%M%S')"
pushd ~/
tar -cvzf "$PACKAGES/kubebinaries_$dt.tar.gz" $NEW_BINARIES
popd

echo "add script and files"
scp -i "$KEY_FILE" update-windows.sh "$SSH_USER@$MASTERIP:"
scp -i "$KEY_FILE" "~/$PACKAGES/kubebinaries_$dt.tar.gz" "$SSH_USER@$MASTERIP:"

echo "kick off update"
ssh -t -i "$KEY_FILE" "$SSH_USER@$MASTERIP" "./update-windows.sh $SSH_USER $WIN_PASS kubebinaries_$dt.tar.gz"

echo "complete windows update"