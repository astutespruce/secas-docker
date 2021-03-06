#!/bin/bash

# NOTE: these versions must also be set in the .env
# in the deploy environment
CADDY=caddy:2.3.0-alpine
REDIS=redis:6.0.10-alpine
MBTILESERVER=mbtileserver:latest
MBGLRENDERER=mbgl-renderer:latest


docker pull $CADDY
docker tag $CADDY $DOCKER_REGISTRY/$CADDY
docker push $DOCKER_REGISTRY/$CADDY

docker pull $REDIS
docker tag $REDIS $DOCKER_REGISTRY/$REDIS
docker push $DOCKER_REGISTRY/$REDIS

docker pull consbio/$MBTILESERVER
docker tag consbio/$MBTILESERVER $DOCKER_REGISTRY/$MBTILESERVER
docker push $DOCKER_REGISTRY/$MBTILESERVER

docker pull consbio/$MBGLRENDERER
docker tag consbio/$MBGLRENDERER:latest $DOCKER_REGISTRY/$MBGLRENDERER
docker push $DOCKER_REGISTRY/$MBGLRENDERER