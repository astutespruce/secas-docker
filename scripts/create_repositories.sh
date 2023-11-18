#!/bin/bash
# Create AWS ECR repositories

# KEY_ARN is currently only required variable
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

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/blueprint-api --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/ui-build-base --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

