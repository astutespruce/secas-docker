# GeoPlatform Operations

The following instructions are for managing Docker images within the GeoPlatform
infrastructure. For information about the specific configuration and operations
for a given environment in GeoPlatform, please see the associated documentation:

-   [staging (GeoPlatform)](deploy/staging/README.md)
-   [production (GeoPlatform)](deploy/production/README.md)

Docker images are managed using AWS ECR service within GeoPlatform.

Run-time environment variables are added to the `.env` file in the root of this folder.
These include:

```
DOCKER_REGISTRY=<registry_url>/blueprint
KEY_ARN=<key used to sign images in ECR>
```

Source this into your shell: `source .env`.
(in Fish shell: `export (grep "^[^#]" .env |xargs -L 1)`)

Image versions are managed in the root `public-images` file. Source this into your
shell: `source public-images`.
(in Fish shell: `export (grep "^[^#]" public-images |xargs -L 1)`)

These environment variables must be set to use any of the docker-compose files
in this repo.

Note: for local development, these may be overridden in the `deploy/dev/.env`
file to test newer versions before pushing to GeoPlatform.

## Initial setup

Setup the AWS CLI v2. Add a profile called `geoplatform-test` to the
`~/.aws/credentials` and `~/.aws/config` files.

## Login to ECR

Set an environment variable for the ECR endpoint:

Fetch token to use ECR:

```
aws ecr get-login-password --region us-east-1 --profile geoplatform-test | docker login --username AWS --password-stdin $DOCKER_REGISTRY
```

This is typically required for pushing or pulling images; the token is valid for a limited time.

## Create a repository for each image (once)

```
aws ecr create-repository --profile geoplatform-test --repository-name blueprint/caddy --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/redis --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/mbtileserver --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/mbgl-renderer --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/blueprint-api --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/sa-ui-build --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN

aws ecr create-repository --profile geoplatform-test --repository-name blueprint/se-ui-build --image-scanning-configuration scanOnPush=true --encryption-configuration encryptionType=KMS,kmsKey=$KEY_ARN
```

After creating the repositories, copy and paste the permissions config to each
(from an existing one) using AWS console.

## Push public images from Docker Hub to ECR

Note: the same version of all public images are used in all environments.

To pull, tag, and push images to Geoplatform ECR, run:

```bash
scripts/push_public_images.sh
```

Note: be careful not to do this while Docker image versions are set to local
development versions not ready to be pushed!

## Build and push custom images

Create the UI build image that is used to build the UI on the server.
From within the `ui` folder of the applicable deploy folder:

```bash
docker-compose -f docker-compose.yml build
docker push $DOCKER_REGISTRY/sa-ui-build
```

Create the API / background worker image from the base directory in this repo:
Note: the `PYOGRIO_COMMIT_HASH` must be set to a specific commit hash on that repo.

```bash
docker build -f docker/api/Dockerfile -t blueprint-api:latest --build-arg PYOGRIO_COMMIT_HASH=<hash> .
docker tag blueprint-api:latest $DOCKER_REGISTRY/blueprint-api:latest
docker push $DOCKER_REGISTRY/blueprint-api:latest
```
