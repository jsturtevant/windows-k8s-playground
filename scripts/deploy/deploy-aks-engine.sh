#!/bin/bash

set -e -u -o pipefail

MODEL=${1:?provide model path}

modelname=$(basename $MODEL .json | sed 's/windows/win/g') 
group=test-${modelname}-${RANDOM}

(
    ${ACS_ENGINE_PATH}aks-engine deploy -m $MODEL \
        -l $DEPLOY_REGION \
        -g $group\
        --auth-method client_secret \
        --client-id $AZURE_CLIENT_ID \
        --client-secret $AZURE_CLIENT_SECRET \
        --dns-prefix $group \
        --subscription-id $AZURE_SUBSCRIPTION_ID \
        --set windowsProfile.adminPassword=$PASS \
        --output-directory ${OUTPUT_DIR}/$group \
        -f 
)

echo "Use the following: "
echo "ssh -i ~/out/$group/azureuser_rsa azureuser@$group.$DEPLOY_REGION.cloudapp.azure.com"
echo "kubie ctx -f ~/out/$group/kubeconfig/kubeconfig.$DEPLOY_REGION.json"
echo "kubectl --kubeconfig ~/out/$group/kubeconfig/kubeconfig.$DEPLOY_REGION.json get nodes"
winnode=$(kubectl --kubeconfig ~/out/$group/kubeconfig/kubeconfig.$DEPLOY_REGION.json get node --selector='kubernetes.io/os=windows' -o json | jq -r '.items | .[0].metadata.name')
echo "wssh $group.$DEPLOY_REGION.cloudapp.azure.com $winnode"

