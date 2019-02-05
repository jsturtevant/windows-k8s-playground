#!/usr/bin/env bash

set -x

# usage: 
#   ./update.sh <masterip>
#
# 
PUBIP=${1}
KEY_FILE=${2:-"~/.ssh/id_rsa"}
SSH_USER=${3:-"adminuser"}
NEW_BINARIES=${4:-"$HOME/k8s-binaries"}
PACKAGES=${5:-"$HOME/k8s-packages"}


updateNode(){
    echo "make folders if don't exist"
    ssh -t -i "$KEY_FILE" -o "ProxyCommand ssh -i $KEY_FILE -W %h:%p $SSH_USER@$PUBIP" "$SSH_USER@$2" "powershell -c mkdir c:/temp/dev"
    
    echo "add files"
    scp -i "$KEY_FILE" -o "ProxyCommand ssh -i $KEY_FILE -W %h:%p $SSH_USER@$PUBIP" win-updater.ps1 "$SSH_USER@$2:c:/temp/dev/"
    pushd "$PACKAGES"
    scp -i "$KEY_FILE" -o "ProxyCommand ssh -i $KEY_FILE -W %h:%p $SSH_USER@$PUBIP" "kubebinaries_$dt.tar.gz" "$SSH_USER"@"$2:c:/temp/dev/" 
    popd

    echo "kick off update"
    kubectl drain $1
    ssh -t -i "$KEY_FILE" -o "ProxyCommand ssh -i $KEY_FILE -W %h:%p $SSH_USER@$PUBIP" "$SSH_USER@$2" "powershell -f c:/temp/dev/win-updater.ps1 $3"
    kubectl uncordon $1
}

echo "zip files"
dt="$(date '+%m%d%Y-%H%M%S')"
pushd "$NEW_BINARIES"
tar -cvzhf "$PACKAGES/kubebinaries_$dt.tar.gz" .
popd

echo "updating vm"
windowsnodes="$(kubectl get nodes -o json | jq -rc '.items | map(select(.metadata.labels."beta.kubernetes.io/os" | contains("windows"))?) | map({ nodename: .metadata.name, nodeip: .status.addresses | map(select(.type | contains("InternalIP"))?) | .[] | .address  })[]')"
while read -r node; do
    echo "$node"
    nodename="$(echo "$node" | jq -r .nodename)"
    ip="$(echo "$node" | jq -r .nodeip)"
    echo "updating vm $nodename with ip $ip..."
    updateNode $nodename $ip kubebinaries_$dt.tar.gz
done <<< "$windowsnodes"

echo "complete windows update"