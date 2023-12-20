#!/usr/bin/env bash

REGISTRY="us-central1-docker.pkg.dev/monarch-initiative/monarch-api"
IMAGE_NAME="monarch-neo4j"
IMAGE_TAG="4.4"

FULL_IMAGE_NAME="${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"

docker build \
    --platform linux/amd64 \
    -t ${FULL_IMAGE_NAME} \
    . && \
docker push ${FULL_IMAGE_NAME}
