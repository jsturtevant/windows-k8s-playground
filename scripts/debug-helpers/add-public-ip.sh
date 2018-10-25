#!/usr/bin/env bash

# usage: add-public-ip.sh azwink8s-rg 35681k8s900nic-0

RG=$1
NIC=$2
LOCATION=${3:-eastus}

IPNAME=pub-$((100 + RANDOM % $((500-100))))

# create public ip
az network public-ip create \
    --resource-group $RG \
    --location $LOCATION \
    --name $IPNAME \
    --dns-name $IPNAME 

# assign ip to nic
az network nic ip-config update \
    --resource-group $RG \
    --nic-name $NIC \
    --name ipconfig1 \
    --public-ip $IPNAME