#!/bin/bash

docker push $DOCKER_REGISTRY/sa-ui-build:latest

docker push $DOCKER_REGISTRY/se-ui-build:latest

docker push $DOCKER_REGISTRY/blueprint-api:latest

docker push $DOCKER_REGISTRY/blueprint-renderer:latest