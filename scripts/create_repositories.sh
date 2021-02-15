# Create AWS ECR repositories

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/caddy --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/redis --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/mbtileserver --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/mbgl-renderer --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/blueprint-api --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/sa-ui-build --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/se-ui-build --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN