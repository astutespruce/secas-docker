#!/bin/bash

# UI Build
docker-compose -f docker/ui/docker-compose.yml build ui-build-base

# API / Worker
docker-compose -f docker/api/docker-compose.yml build blueprint-api
