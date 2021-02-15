#!/bin/bash

docker push $DOCKER_REGISTRY/blueprint-ui:latest

docker push $DOCKER_REGISTRY/blueprint-api:latest
