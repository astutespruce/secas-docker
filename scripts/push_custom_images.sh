#!/bin/bash

docker push $DOCKER_REGISTRY/ui-build-base:latest

docker push $DOCKER_REGISTRY/blueprint-api:latest
