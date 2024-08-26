#!/bin/bash


for VARIABLE in SSA_STATIC_DIR SSA_CODE_DIR
do
    if [[ -z ${!VARIABLE} ]]; then
        echo "$VARIABLE must be set" 1>&2
        exit 1
    fi
done

echo "Deploying UI to $SSA_STATIC_DIR"

if docker compose -f ./docker/ui/docker-compose.yml run --rm --user app ssa-ui-build npm run deploy; then
    echo "====> UI build succeeded"
    rm -rf $SSA_STATIC_DIR/*
    cp -r $SSA_CODE_DIR/ui/public/* $SSA_STATIC_DIR
else
    echo "====> ERROR: UI build failed"
fi
