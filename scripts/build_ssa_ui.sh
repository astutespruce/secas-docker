#!/bin/bash


for VARIABLE in STATIC_DIR SSA_CODE_DIR
do
    if [[ -z ${!VARIABLE} ]]; then
        echo "$VARIABLE must be set" 1>&2
        exit 1
    fi
done

echo "Deploying UI to $STATIC_DIR/ssa"

if docker-compose -f ./docker/ui/docker-compose.yml run --rm --user app ssa-ui-build npm run deploy; then
    echo "====> UI build succeeded"
    rm -rf $STATIC_DIR/ssa/*
    cp -r $SA_CODE_DIR/ui/public/* $STATIC_DIR/ssa
else
    echo "====> ERROR: UI build failed"
fi
