VERSION=v1.19.4

curl -L https://raw.githubusercontent.com/kubernetes-sigs/windows-testing/master/images/image-repo-list -o ./repolist.yaml

set -x
docker run --rm -v $PWD/kubeconfig:/tmp/kubeconfig \
    -v $PWD/repolist.yaml:/tmp/repolist.yaml \
    -e KUBE_TEST_REPO_LIST=/tmp/repolist.yaml \
    us.gcr.io/k8s-artifacts-prod/conformance:$VERSION  \
    /usr/local/bin/e2e.test --kubeconfig=/tmp/kubeconfig \
    --provider=skeleton --ginkgo.noColor  --node-os-distro="windows" \
    --delete-namespace-on-failure=false \
    --ginkgo.focus="$1"