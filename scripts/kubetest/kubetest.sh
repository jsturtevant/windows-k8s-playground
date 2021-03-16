#!/bin/bash

# MUST run from go/src/k8s.io/kubernetes

export K8S_SSH_PUBLIC_KEY_PATH="${HOME}/.ssh/id_rsa.pub"
export K8S_SSH_PRIVATE_KEY_PATH="${HOME}/.ssh/id_rsa"
export AZURE_CREDENTIALS="${HOME}/azure/azure.toml"
export ARTIFACTS="${HOME}/out/kubetest"
export REGISTRY="jstur.azurecr.io"
export WIN_BUILD="https://raw.githubusercontent.com/kubernetes-sigs/windows-testing/master/build/build-windows-k8s.sh"
export KUBE_TEST_REPO_LIST_DOWNLOAD_LOCATION="https://raw.githubusercontent.com/kubernetes-sigs/windows-testing/master/images/image-repo-list-master"
export AZ_STORAGE_CONTAINER_NAME="k8s"

#ginkofocus="GMSA"
ginkofocus="Windows.volume.mounts"

kubetest --test=true \
    --up \
    --dump=$ARTIFACTS \
    --provider=skeleton \
    --build=quick \
    --aksengine-deploy-custom-k8s \
    --deployment=aksengine \
    --aksengine-win-binaries \
    --aksengine-winZipBuildScript=$WIN_BUILD \
    --aksengine-admin-username=azureuser \
    --aksengine-location westus2 \
    --aksengine-admin-password=zse4Xdr5cft6 \
    --aksengine-creds=$AZURE_CREDENTIALS \
    --aksengine-download-url=https://aka.ms/aks-engine/aks-engine-k8s-e2e.tar.gz \
    --aksengine-public-key=$K8S_SSH_PUBLIC_KEY_PATH \
    --aksengine-private-key=$K8S_SSH_PRIVATE_KEY_PATH \
    --aksengine-orchestratorRelease=1.21 \
    --aksengine-template-url=https://raw.githubusercontent.com/kubernetes-sigs/windows-testing/master/job-templates/kubernetes_containerd_master.json \
    --aksengine-agentpoolcount=2 \
    --test_args="--node-os-distro=windows --ginkgo.focus=$ginkofocus --ginkgo.skip=\[LinuxOnly\]" \
    --ginkgo-parallel=8

mv $HOME/tmp* $ARTIFACTS

# enable and build {GOPATH}/src/k8s.io/kubernetes
    # --build=quick \
    # --aksengine-deploy-custom-k8s \
    # --deployment=aksengine \
    # --aksengine-win-binaries \
    # --aksengine-winZipBuildScript=$WIN_BUILD \

# run the e2e just built until fails
# export GINKGO_UNTIL_IT_FAILS=true
# export GINKGO_PARALLEL_NODES=8
# ./hack/ginkgo-e2e.sh --node-os-distro=windows --ginkgo.focus=Downward.API.volume.should.provide.container --ginkgo.skip="\[LinuxOnly\]" --report-dir=/home/jstur/out/kubetest --disable-log-dump=true 
