#!/usr/bin/env bash

# usage: 
#   export WIN_PASS=<yourpass>
#   ./copy-out.sh 12.34.45.6   

MASTERIP=$1
BINARY_LOCATION=${2:-"~/k8s-binaries/"}
SSH_USER=${3:-"adminuser"}
KEY_FILE=${4:-"~/.ssh/id_rsa"}

ssh -t -i "$KEY_FILE" "$SSH_USER@$MASTERIP":~/go/src/k8s.io/kubernetes/_output/dockerized/bin/windows/amd64/* $BINARY_LOCATION