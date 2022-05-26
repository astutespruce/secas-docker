#!/bin/bash

# NOTE: these versions must also be set in the .env
# in the deploy environment
CADDY=caddy:2.5.1-alpine
REDIS=redis:7.0.0-alpine
MBTILESERVER=mbtileserver:0.8.2


docker pull $CADDY
docker tag $CADDY $DOCKER_REGISTRY/$CADDY
docker push $DOCKER_REGISTRY/$CADDY

docker pull $REDIS
docker tag $REDIS $DOCKER_REGISTRY/$REDIS
docker push $DOCKER_REGISTRY/$REDIS

docker pull consbio/$MBTILESERVER
docker tag consbio/$MBTILESERVER $DOCKER_REGISTRY/$MBTILESERVER
docker push $DOCKER_REGISTRY/$MBTILESERVER
