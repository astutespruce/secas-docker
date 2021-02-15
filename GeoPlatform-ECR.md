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
PYOGRIO_COMMIT_HASH=<commit hash in pyogrio repository to use for building API>
DEPLOY_ENV=<deploy environment; one of dev, staging, production>
SA_CODE_DIR=<location of sa-blueprint-sv repo>
SA_DATA_DIR=<location of data files for SA>
SE_CODE_DIR=<location of secas-blueprint repo>
SE_DATA_DIR=<location of data files for SE>
STATIC_DIR=<location to which static UI assets are deployed>
TILE_DIR=<location of tiles>
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
scripts/create_repositories.sh
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

Build:

```bash
scripts/build_custom_images.sh
```

Push:

```bash
scripts/push_custom_images.sh
```
