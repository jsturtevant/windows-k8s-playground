#!/usr/bin/env bash

# use in conjunction with update.sh

docker run --rm -v ~/.kube/config:/root/.kube/config -v $PWD/$3:/opt/k/out jsturtevant/wink8s-updater:v0.1.0 -win_user $1 -win_pass $2