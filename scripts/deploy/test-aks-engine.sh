#!/bin/bash -x

export GINKGO_FOCUS=${GINKGO_FOCUS:-"should.be.able.to.rotate.docker.logs"}


ORCHESTRATOR_RELEASE=1.18 \
    CLUSTER_DEFINITION="../windows-k8s-playground/aks-engine-models/simple-windows.json" \
    SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID \
    CLIENT_ID=$AZURE_CLIENT_ID \
    CLIENT_SECRET=$AZURE_CLIENT_SECRET \
    TENANT_ID=$AZURE_TENANT_ID \
    LOCATION=$DEPLOY_REGION \
    CLEANUP_ON_EXIT=false \
    OUTPUT_DIR="./_output" \
    GINKGO_FOCUS=$GINKGO_FOCUS \
    GINKGO_SKIP="" \
    GINKGO_FAIL_FAST=true \
    VALIDATE_CPU_LOAD="false" \
    NAME="kubernetes-westus2-23861" \
    USE_MANAGED_IDENTITY="false" \
    SKIP_TESTS="true" \
    make test-kubernetes


## kubie ctx -f _output/kubernetes-westus2-90206/kubeconfig/kubeconfig.westus2.json
## wssh kubernetes-westus2-90206.westus2.cloudapp.azure.com 2103k8s00000000