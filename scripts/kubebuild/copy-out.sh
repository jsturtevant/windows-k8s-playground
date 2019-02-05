#!/usr/bin/env bash

# usage: 
#   export WIN_PASS=<yourpass>
#   ./copy-out.sh 12.34.45.6   

MASTERIP=$1
BINARY_LOCATION=${2:-"$HOME/k8s-binaries/kube"}
SSH_USER=${3:-"jstur"}
KEY_FILE=${4:-"~/.ssh/id_rsa"}

scp -i "$KEY_FILE" "$SSH_USER@$MASTERIP":~/go/src/k8s.io/kubernetes/_output/dockerized/bin/windows/amd64/kubelet.exe $BINARY_LOCATION
scp -i "$KEY_FILE" "$SSH_USER@$MASTERIP":~/go/src/k8s.io/kubernetes/_output/dockerized/bin/windows/amd64/kube-proxy.exe $BINARY_LOCATION