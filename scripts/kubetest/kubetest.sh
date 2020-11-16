#!/bin/bash

# run from go/src/k8s.io/kubernetes

export K8S_SSH_PUBLIC_KEY_PATH="${HOME}/.ssh/id_rsa.pub"
export K8S_SSH_PRIVATE_KEY_PATH="${HOME}/.ssh/id_rsa"
export AZURE_CREDENTIALS="${HOME}/azure/azure.toml"
export ARTIFACTS="${HOME}/out/kubetest"
export REGISTRY="jstur.azurecr.io"
export WIN_BUILD="https://raw.githubusercontent.com/kubernetes-sigs/windows-testing/master/build/build-windows-k8s.sh"
export KUBE_TEST_REPO_LIST_DOWNLOAD_LOCATION="https://raw.githubusercontent.com/kubernetes-sigs/windows-testing/master/images/image-repo-list"
export AZ_STORAGE_CONTAINER_NAME="k8s"

#ginkofocus="GMSA"
ginkofocus="(\[sig-windows\]|\[sig-scheduling\].SchedulerPreemption|\[sig-autoscaling\].\[Feature:HPA\]|\[sig-apps\].CronJob).*(\[Serial\]|\[Slow\])|(\[Serial\]|\[Slow\]).*(\[Conformance\]|\[NodeConformance\])"

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
    --aksengine-orchestratorRelease=1.20 \
    --aksengine-template-url=https://raw.githubusercontent.com/kubernetes-sigs/windows-testing/master/job-templates/kubernetes_release_staging.json \
    --aksengine-agentpoolcount=2 \
    --test_args="--ginkgo.flakeAttempts=2 --node-os-distro=windows --ginkgo.focus=$ginkofocus --ginkgo.skip=\[LinuxOnly\]" \
    --ginkgo-parallel=6

mv $HOME/tmp* $ARTIFACTS

# enable and build {GOPATH}/src/k8s.io/kubernetes
    # --build=quick \
    # --aksengine-deploy-custom-k8s \
    # --deployment=aksengine \
    # --aksengine-win-binaries \
    # --aksengine-winZipBuildScript=$WIN_BUILD \

