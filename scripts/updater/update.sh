#!/usr/bin/env bash

set +x
set -e -u -o pipefail

# usage: 
#   ./update.sh <masterip>
#
# 
PUBIP=${1}
KEY_FILE=${2:-"~/.ssh/id_rsa"}
SSH_USER=${3:-"azureuser"}
NEW_BINARIES=${4:-"$GOPATH/src/k8s.io/kubernetes/_output/dockerized/bin/windows/amd64"}
PACKAGES=${5:-"$HOME/k8s-packages"}
FILE_ROOT=$(dirname "${BASH_SOURCE[0]}")

updateNode(){
    echo "make folders if don't exist"
    ssh -i "$KEY_FILE" -o "ProxyCommand ssh -i $KEY_FILE -W %h:%p $SSH_USER@$PUBIP" "$SSH_USER@$2" "powershell -c mkdir -force c:/temp/dev"
    
    echo "add files"
    scp -i "$KEY_FILE" -o "ProxyCommand ssh -i $KEY_FILE -W %h:%p $SSH_USER@$PUBIP" $FILE_ROOT/win-updater.ps1 "$SSH_USER@$2:c:/temp/dev/"
    pushd "$PACKAGES"
    scp -i "$KEY_FILE" -o "ProxyCommand ssh -i $KEY_FILE -W %h:%p $SSH_USER@$PUBIP" "kubebinaries_$dt.tar.gz" "$SSH_USER"@"$2:c:/temp/dev/" 
    popd

    echo "kick off update"
    kubectl drain $1
    ssh -i "$KEY_FILE" -o "ProxyCommand ssh -i $KEY_FILE -W %h:%p $SSH_USER@$PUBIP" "$SSH_USER@$2" "powershell -f c:/temp/dev/win-updater.ps1 $3"
    kubectl uncordon $1
}

mkdir -p $PACKAGES

echo "zip files in $NEW_BINARIES to $PACKAGES"
dt="$(date '+%m%d%Y-%H%M%S')"
pushd "$NEW_BINARIES"
tar -cvzhf "$PACKAGES/kubebinaries_$dt.tar.gz" .
popd

echo "updating vm"
windowsnodes="$(kubectl get nodes -o json | jq -rc '.items | map(select(.metadata.labels."kubernetes.io/os" | contains("windows"))?) | map({ nodename: .metadata.name, nodeip: .status.addresses | map(select(.type | contains("InternalIP"))?) | .[] | .address  })[]')"
while read -r node; do
    echo "$node"
    nodename="$(echo "$node" | jq -r .nodename)"
    ip="$(echo "$node" | jq -r .nodeip)"
    echo "updating vm $nodename with ip $ip..."
    updateNode $nodename $ip kubebinaries_$dt.tar.gz
done <<< "$windowsnodes"

echo "complete windows update"