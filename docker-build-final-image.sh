#!/usr/bin/env sh

read -r VERSION_NUMBER < version.txt

docker build \
    --target final-image \
    --tag mattifesto/controller:$VERSION_NUMBER \
    --tag mattifesto/controller:latest \
    .
