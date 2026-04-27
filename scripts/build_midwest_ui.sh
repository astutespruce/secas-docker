#!/bin/bash


for VARIABLE in MIDWEST_BLUEPRINT_STATIC_DIR MIDWEST_BLUEPRINT_CODE_DIR
do
    if [[ -z ${!VARIABLE} ]]; then
        echo "$VARIABLE must be set" 1>&2
        exit 1
    fi
done

echo "Deploying UI to $MIDWEST_BLUEPRINT_STATIC_DIR"

if docker compose -f ./docker/ui/docker-compose.yml run --rm --user app midwest-ui-build npm run deploy; then
    echo "====> UI build succeeded"
    rm -rf $MIDWEST_BLUEPRINT_STATIC_DIR/*
    cp -r $MIDWEST_BLUEPRINT_CODE_DIR/ui/public/* $MIDWEST_BLUEPRINT_STATIC_DIR
else
    echo "====> ERROR: UI build failed"
fi
