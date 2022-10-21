# GeoPlatform Operations

The following instructions are for managing Docker images within the GeoPlatform
infrastructure. For information about the specific configuration and operations
for a given environment in GeoPlatform, please see the associated documentation:

-   [staging (GeoPlatform)](deploy/staging/README.md)
-   [production (GeoPlatform)](deploy/production/README.md)

Docker images are managed using AWS ECR service within GeoPlatform.

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

## Support

All requests for assistance with the environment go to gishelpdesk @ zivaro.com

Zivaro staff provide uptime monitoring, patching, and management of the AWS infrastructure.
