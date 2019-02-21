#!/usr/bin/env bash

# clean up previous run
docker rmi -f build:stage1

# create a container with tmpfs and send it to the background
docker run --runtime runq -td --tmpfs /tmp --name mybuild1 python:3-slim-stretch
sleep 2  # give runq a few seconds

# install whatever dependencies we want
# -- anything that requires the tmpfs to function in /tmp
/var/lib/runq/runq-exec mybuild1 apt update -y
/var/lib/runq/runq-exec mybuild1 apt list --upgradable
#/var/lib/runq/runq-exec mybuild1 apt upgrade -y
#/var/lib/runq/runq-exec mybuild1 apt install -y git

# stop the container and commit it as a local image
docker stop mybuild1
docker container commit mybuild1 build:stage1

# run a docker build with the local image
unset DOCKER_CONTENT_TRUST  # This was necessary, but we should understand why
docker build -t build:stage2 .

docker run build:stage2
