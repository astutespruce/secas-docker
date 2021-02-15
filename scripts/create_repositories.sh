#!/bin/bash
# Create AWS ECR repositories


for VARIABLE in KEY_ARN
do
    if [[ -z ${!VARIABLE} ]]; then
        echo "$VARIABLE must be set" 1>&2
        exit 1
    fi
done


aws ecr create-repository --profile geoplatform-test --repository-name blueprint/caddy --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/redis --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/mbtileserver --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/mbgl-renderer --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/blueprint-api --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/blueprint-ui --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

