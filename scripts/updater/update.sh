#!/usr/bin/env bash

# usage: 
#   export WIN_PASS=<yourpass>
#   ./update.sh 12.34.45.6   

MASTERIP=$1
NEW_BINARIES=${2:-"~/k8s-binaries/"}
SSH_USER=${3:-"adminuser"}
KEY_FILE=${4:-"~/.ssh/id_rsa"}

echo "zip files and upload to master"


echo "add script to kick off update on windows"
scp -i "$KEY_FILE" update-windows.sh  "$SSH_USER@$MASTERIP:"
ssh -t -i "$KEY_FILE" "$SSH_USER@$MASTERIP" "./update-windows.sh $SSH_USER $WIN_PASS $MASTERIP"

echo "complete windows update"