#!/bin/bash

set -e -u -o pipefail

(
    optional_args=( )
    [[ $WINDOWS_DOCKER_VERSION ]] && optional_args+=("--set windowsProfile.windowsDockerVersion=$WINDOWS_DOCKER_VERSION" )
    [[ $WINDOWS_KUBE_BINARIES_URL ]] && optional_args+=("--set orchestratorProfile.kubernetesConfig.windowsNodeBinariesURL=$WINDOWS_KUBE_BINARIES_URL" )
    [[ $WINDOWS_AZURE_CNI_URL ]] && optional_args+=("--set orchestratorProfile.kubernetesConfig.azureCNIURLWindows=$WINDOWS_AZURE_CNI_URL" )
    [[ $LINUX_AZURE_CNI_URL ]] && optional_args+=("--set orchestratorProfile.kubernetesConfig.azureCNIURLLinux=$LINUX_AZURE_CNI_URL" )
    [[ $LINUX_HYPERKUBE_IMAGE ]] && optional_args+=("--set orchestratorProfile.kubernetesConfig.customHyperkubeImage=$LINUX_HYPERKUBE_IMAGE" )
    [[ $WINDOWS_CONTAINERD_URL ]] && optional_args+=("--set orchestratorProfile.kubernetesConfig.windowsContainerdURL=$WINDOWS_CONTAINERD_URL" )

    $ACS_ENGINE_PATH/aks-engine deploy -m $CONFIG_PATH/windows-conformance.json \
        -l $DEPLOY_REGION \
        -g $DEPLOY_RESOURCE_GROUP \
        --auth-method client_secret \
        --client-id $AZURE_CLIENT_ID \
        --client-secret $AZURE_CLIENT_SECRET \
        --dns-prefix $DEPLOY_RESOURCE_GROUP \
        --auto-suffix \
        --subscription-id $AZURE_SUBSCRIPTION_ID \
        --set windowsProfile.adminPassword=$pass \
        --output-directory $OUTPUT_DIR \
        -f \
        ${optional_args[@]}
)