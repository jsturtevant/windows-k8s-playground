#!/usr/bin/env bash

set -x

# usage: 
#   export WIN_PASS=<yourpass>
#   ./update.sh 
#
# currently assumes binaries are in ~

KEY_FILE=${1:-"~/.ssh/id_rsa"}
SSH_USER=${2:-"adminuser"}
NEW_BINARIES=${3:-"k8s-binaries"}
PACKAGES=${4:-"k8s-packages"}

updateNode(){
    echo "add script and files"
    scp -i "$KEY_FILE" win-updater.ps1 "$SSH_USER@$2:"
    pushd ~/
    scp -i "$KEY_FILE" "$PACKAGES/kubebinaries_$dt.tar.gz" "$SSH_USER@$2:"
    popd

    echo "kick off update"
    kubectl drain $1
    ssh -t -i "$KEY_FILE" "$SSH_USER@$2" "powershell -f win-updater.ps1 $3"
    kubectl uncordon $1
}

echo "zip files"
dt="$(date '+%m%d%Y-%H%M%S')"
pushd ~/
tar -cvzhf "$PACKAGES/kubebinaries_$dt.tar.gz" $NEW_BINARIES
popd

echo "updating vm"
windowsnodes="$(kubectl get nodes -o json | jq -rc '.items | map(select(.metadata.labels."beta.kubernetes.io/os" | contains("windows"))?) | map({ nodename: .metadata.name, pubip: .status.addresses | map(select(.type | contains("ExternalIP"))?) | .[] | .address  })[]')"
while read -r node; do
    echo "$node"
    nodename="$(echo "$node" | jq -r .nodename)"
    ip="$(echo "$node" | jq -r .pubip)"
    echo "updating vm $nodename with ip $ip..."
    updateNode $nodename $ip kubebinaries_$dt.tar.gz
done <<< "$windowsnodes"

echo "complete windows update"