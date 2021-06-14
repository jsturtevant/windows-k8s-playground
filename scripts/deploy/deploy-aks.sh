#!/bin/bash

set -x

version="${1:-1.20.2}"
rg=test-aks-$RANDOM
location="${location:-eastus}"
WINDOWS_USERNAME="azureuser"
ADMIN_PASS="${ADMIN_PASS:-changeMe2234}"

clustername="$rg-cluster"

az group create --name $rg --location $location

az aks create \
    --resource-group $rg \
    --name $clustername \
    --node-count 1 \
    --enable-addons monitoring \
    --generate-ssh-keys \
    --windows-admin-username $WINDOWS_USERNAME \
    --vm-set-type VirtualMachineScaleSets \
    --kubernetes-version $version \
    --network-plugin azure \
    --windows-admin-password $ADMIN_PASS

az aks nodepool add \
    --resource-group $rg \
    --cluster-name $clustername \
    --os-type Windows \
    --name npwin \
    --node-count 2

az aks get-credentials --resource-group $rg --name $clustername