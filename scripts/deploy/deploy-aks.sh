#!/bin/bash

set -x

version="${1:-1.20.2}"
rg=test-aks-$RANDOM
location="${location:-eastus}"
WINDOWS_USERNAME="azureuser"
ADMIN_PASS="${ADMIN_PASS:-zse4Xdr5cft6zse4Xdr5cft6}"

clustername="$rg-cluster"

az group create --name $rg --location $location

#    --enable-addons monitoring \
az aks create \
    --resource-group $rg \
    --name $clustername \
    --node-count 1 \
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
    --node-vm-size Standard_D4s_v3 \
    --node-count 1

az aks get-credentials --resource-group $rg --name $clustername