#!/usr/bin/env bash

# use in conjunction with update.sh

docker pull jsturtevant/wink8s-updater:latest
docker run --rm -v ~/.kube/config:/root/.kube/config -v $PWD:/app/package jsturtevant/wink8s-updater:latest -win_user $1 -win_pass $2 -package $3