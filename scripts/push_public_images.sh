#!/bin/bash

# NOTE: these versions must also be set in the .env
# in the deploy environment and sourced before running here
# CADDY=caddy:2.7.6-alpine
# REDIS=redis:7.2.4-alpine
# MBTILESERVER=mbtileserver:0.10.0


# NOTE: pull only the linux/amd images for use on Geoplatform

docker pull $CADDY --platform linux/amd64
docker tag $CADDY $DOCKER_REGISTRY/$CADDY
docker push $DOCKER_REGISTRY/$CADDY

docker pull $REDIS --platform linux/amd64
docker tag $REDIS $DOCKER_REGISTRY/$REDIS
docker push $DOCKER_REGISTRY/$REDIS

docker pull ghcr.io/consbio/$MBTILESERVER --platform linux/amd64
docker tag ghcr.io/consbio/$MBTILESERVER $DOCKER_REGISTRY/$MBTILESERVER
docker push $DOCKER_REGISTRY/$MBTILESERVER
