# GeoPlatform Operations

The following instructions are for managing Docker images within the GeoPlatform
infrastructure. For information about the specific configuration and operations
for a given environment in GeoPlatform, please see the associated documentation:

-   [staging (GeoPlatform)](deploy/staging/README.md)
-   [production (GeoPlatform)](deploy/production/README.md)

Docker images are managed using AWS Elastic Container Registry (ECR) service
within GeoPlatform.

IMPORTANT: the ECR service used by this project is contained within the staging
AWS account; the production environment can download images from this environment.

## Concepts:

Each repository in the GeoPlatform ECR is used for a single Docker image; it
may contain prior versions of an image, but those are periodically removed
once no longer used on any of the servers.

Each Docker image provides a runtime environment that executes code on the server.
We use these in this project in 3 main ways:

-   always-on, single-service, single image: the Docker image is used to provide
    a single service that is always running; for example, the Caddy reverse proxy
    image.
-   always-on, multiple-service, single image: the Docker image is used to provide
    the runtime for multiple services that are always running. The actual code
    of the services lives on the host machine and is executed by a Docker container
    created from the Docker image.
-   on-demand: the Docker image provides a runtime that is used on demand rather
    than always running; for example, the user-interface build step.

## Initial local development setup

Install and configure the AWS CLI v2 on your development computer. Add a profile
called `geoplatform-test` to the `~/.aws/credentials` file with the programmatic
AWS access and secret keys provided by Zivaro for your individual IAM account:

```bash
[geoplatform-test]
aws_access_key_id=<your access key>
aws_secret_access_key=<your secret key>
```

Add this profile to the `~/.aws/config` file:

```bash

[profile geoplatform-test]
region = us-east-1
```

Create a `.env` file in the root of this repository with the following entries:

```bash
DOCKER_REGISTRY=<ECR registry ID>/blueprint
KEY_ARN=<ECR Key ARN>
```

The ECR registry ID is visible within the list of uploaded images available in
the [AWS console](https://us-east-1.console.aws.amazon.com/ecr/repositories?region=us-east-1), because everything is named `<ECR registry ID>/blueprint/<image ID>.

The ECR Key ARN can be obtained by selecting one of the image repositories, e.g.,
`<ECR registry ID>/blueprint/blueprint-api` and choosing Edit Repository from
the actions menu. The Key ARN is displayed toward the bottom of the page.

## Login to ECR from development computer

Load the environment variables created above.

In bash and similar:

```bash
set -a
source .env
```

In fish shell:

```fish
export (grep "^[^#]" .env |xargs -L 1)
```

Retrieve short-term credentials:
Use the PIV-based login workflow to login to the AWS account, then under the
test account, click `Command line or programmatic access`.

Copy the contents of Option 2 into your `~/.aws/config` file, which will look
like:

```bash
[account_ID]
aws_access_key_id = <key>
aws_secret_access_key = <key>
aws_session_token = <token>
```

prefix the `[account_ID]` with `profile` so it looks like `[profile account_ID]`.

IMPORTANT: these credentials are only valid for a short period.

Fetch AWS token to use ECR using the `account_ID` from above (exported as `AWS_ACCOUNT_ID` env var):

```bash
aws ecr get-login-password --region us-east-1 --profile $AWS_ACCOUNT_ID | docker login --username AWS --password-stdin $DOCKER_REGISTRY
```

NOTE token is valid for a limited time; you will need to run the above if it
has been some time (several hours) since you last acquired a token.

## Create a repository for each image (only once for each unique Docker image)

```
scripts/create_repositories.sh
```

After creating the repositories, copy and paste the permissions config to each
(from an existing one) using AWS console. This is required in order to grant
the production environment access to the images and to allow programmatic
access to download the images.

From within AWS console, select an existing repostory, and choose Permissions
from the Actions dropdown. Then click "Edit policy JSON" in the upper right,
and copy the JSON it displays. Then select the new repository from the list of
repositories, click Permissions from Actions dropdown, Edit policy JSON, and
paste in the JSON you just copied. Then click Save.

If you get permission errors when attempting to pull images to the staging or
production environment, this may be the source of the errors.

## Push public images from Docker Hub to ECR

Note: the same version of all public images are used in all environments; these
are set in the `.env` of that environment. Source that `.env` file in your
shell.

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

## Pulling images and running services

Please see the documentation for the specific environment:

-   [staging (GeoPlatform)](deploy/staging/README.md)
-   [production (GeoPlatform)](deploy/production/README.md)

## Support

All requests for assistance with the environment go to gishelpdesk @ zivaro.com

Zivaro staff provide uptime monitoring, patching, and management of the AWS infrastructure.
