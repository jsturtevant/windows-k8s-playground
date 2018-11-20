#!/usr/bin/env bash

# usage: 
#   export WIN_PASS=<yourpass>
#   ./dump-logs.ssh 12.34.45.6   

MASTERIP=$1
SSH_USER=${2:-"adminuser"}
KEY_FILE=${3:-"~/.ssh/id_rsa"}

scp -i "$KEY_FILE" collect-logs.sh  "$SSH_USER@$MASTERIP:"
ssh -t -i "$KEY_FILE" "$SSH_USER@$MASTERIP" "./collect-logs.sh $SSH_USER $WIN_PASS $MASTERIP"
mkdir -p $MASTERIP
scp -i "$KEY_FILE" -r "$SSH_USER@$MASTERIP:$MASTERIP/" $MASTERIP