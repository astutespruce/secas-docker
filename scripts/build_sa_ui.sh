#!/bin/bash


for VARIABLE in STATIC_DIR SA_CODE_DIR
do
    if [[ -z ${!VARIABLE} ]]; then
        echo "$VARIABLE must be set" 1>&2
        exit 1
    fi
done

echo "Deploying UI to $STATIC_DIR/southatlantic"

if docker-compose -f ./docker/ui/docker-compose.yml run --rm sa-ui npm run deploy --prefix-paths; then
    echo "====> UI build succeeded"
    rm -rf $STATIC_DIR/southatlantic/*
    cp -r $SA_CODE_DIR/ui/public/* $STATIC_DIR/southatlantic
else
    echo "====> ERROR: UI build failed"
fi
