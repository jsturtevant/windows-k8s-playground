#!/usr/bin/env bash

# use in conjunction with dump-logs.sh

docker run --rm -v ~/.kube/config:/root/.kube/config -v $PWD/$3:/opt/k/out jsturtevant/logslurp:v0.1.0 -win_user $1 -win_pass $2