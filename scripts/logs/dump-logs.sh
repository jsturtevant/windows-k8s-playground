#!/usr/bin/env bash

set -x

# usage: 
#   export WIN_PASS=<yourpass>
#   ./dump-logs.ssh 12.34.45.6   

MASTERIP=$1
SSH_USER=${2:-"adminuser"}
KEY_FILE=${3:-"~/.ssh/id_rsa"}


collectlogs(){
    mkdir -p $HOME/k8s-logs/$MASTERIP/$1
    scp -r -o "ProxyCommand ssh -W %h:%p $SSH_USER@$MASTERIP" $SSH_USER@$2:'c:\k\*.log' $HOME/k8s-logs/$MASTERIP/$1/
}

echo "store logs by master ip"
mkdir -p $HOME/k8s-logs/$MASTERIP

echo "colleting windows logs"
windowsnodes="$(kubectl get nodes -o json | jq -rc '.items | map(select(.metadata.labels."beta.kubernetes.io/os" | contains("windows"))?) | map({ nodename: .metadata.name, nodeip: .status.addresses | map(select(.type | contains("InternalIP"))?) | .[] | .address  })[]')"
while read -r node; do
    echo "$node"
    nodename="$(echo "$node" | jq -r .nodename)"
    ip="$(echo "$node" | jq -r .nodeip)"
    echo "updating vm $nodename with ip $ip..."
    collectlogs $nodename $ip
done <<< "$windowsnodes"