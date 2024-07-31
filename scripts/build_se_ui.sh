#!/bin/bash


for VARIABLE in STATIC_DIR SE_CODE_DIR
do
    if [[ -z ${!VARIABLE} ]]; then
        echo "$VARIABLE must be set" 1>&2
        exit 1
    fi
done

echo "Deploying UI to $STATIC_DIR/southeast"

if docker compose -f ./docker/ui/docker-compose.yml run --rm --user app se-ui-build npm run deploy; then
    echo "====> UI build succeeded"
    rm -rf $STATIC_DIR/southeast/*
    cp -r $SE_CODE_DIR/ui/public/* $STATIC_DIR/southeast
else
    echo "====> ERROR: UI build failed"
fi
