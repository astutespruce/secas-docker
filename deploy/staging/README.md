# South Atlantic Simple Viewer Deployment - DOI GeoPlatform - Staging

## Instance setup

Upgrade `docker-compose`:

1. uninstall installation via `apt-get`: `sudo apt-get remove docker-compose`
2. Install using `curl` using link on docker-compose website.

Everything is run as `app` user. Create user and transfer ownership of main directories:

```bash
sudo useradd --create-home app
sudo usermod -aG docker app
sudo chown app:app /var/www
sudo chown app:app /data
usermod --shell /bin/bash app
```

Add current domain user to `app` group:

```bash
sudo usermod -a -G app <domain user>
```

As `app` user:

```bash
rm -rf /var/www/html
mkdir /var/www/southatlantic
mkdir /var/www/southeast
mkdir /data/sa
mkdir /data/se
mkdir /data/tiles
cd ~
git clone https://github.com/astutespruce/secas-docker.git
git clone https://github.com/astutespruce/sa-blueprint-sv.git
git clone https://github.com/astutespruce/secas-blueprint.git
```

### Environment setup

Set up a root `.env` file as described in the
[GeoPlatform operating instructions](../../GeoPlatform.md).

```
DOCKER_REGISTRY=971829237832.dkr.ecr.us-east-1.amazonaws.com/blueprint
KEY_ARN=arn:aws:kms:us-east-1:971829237832:key/0814e3ec-d2b4-493f-a3c0-6e1ef8acb121
SA_CODE_DIR=/home/app/sa-blueprint-sv
SA_DATA_DIR=/data/southatlantic
SE_CODE_DIR=/home/app/secas-blueprint
SE_DATA_DIR=/data/southeast
STATIC_DIR=/var/www
TILE_DIR=/data/tiles
```

This file must be sourced to perform any Docker operaitons.

Also create a `.env` file in this folder with the following:

```
COMPOSE_PROJECT_NAME=secas
MAPBOX_ACCESS_TOKEN=<token>
API_TOKEN=<token>
API_SECRET=<secret>
LOGGING_LEVEL=DEBUG
REDIS_HOST=redis
MBGLRENDER_HOST=renderer
ALLOWED_ORIGINS=<hosts>
SENTRY_DSN=<DSN>
SENTRY_ENV=<env>
ROOT_URL=<URL>

CADDY=<caddy version>
REDIS=<redis version>
MBTILESERVER=<mbtileserver version>
MBGLRENDERER=<renderer version>
```

Use `scripts/set_env.sh` to set these variables:

```bash
ENV=staging scripts/set_env.sh
```

If that doesn't work:

```bash
set -a
source deploy/staging/.env
```

### Pull images (to the EC2 instance)

As `app` user:

Create Docker token:

```bash
export DOCKER_REGISTRY=<registry>
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $DOCKER_REGISTRY
```

Pull images in this folder:

```bash
docker-compose pull
```

Note: the UI dependencies are baked into each UI Builder image; if dependencies
are updated, they will need to be rebuilt and pushed.

### Build the UI

Create `~/sa-blueprint-sv/ui/.env.production` and
`~/secas-blueprint/ui/.env.production` with the following:

```
GATSBY_MAPBOX_API_TOKEN=<mb token>
GATSBY_API_TOKEN=<api token>

SITE_URL=<site root URL>
SITE_ROOT_PATH=<southatlantic or southeast>
GATSBY_API_HOST=<site root URL>/<southatlantic or southeast>
GATSBY_TILE_HOST=<site root URL>
GATSBY_SENTRY_DSN=<dsn>
GATSBY_GOOGLE_ANALYTICS_ID=<id>

GATSBY_MS_FORM_EMAIL=<email>
GATSBY_MS_FORM_NAME=<name>
GATSBY_MS_FORM_ORG=<org>
GATSBY_MS_FORM_USE=<use>
GATSBY_MS_FORM_AREANAME=<areaname>
GATSBY_MS_FORM_FILENAME=<filename>
```

Pull the images from the root of this repository:

```bash
docker-compose -f docker/ui/docker-compose.yml pull
```

Then build:

```bash
scripts/build_sa_ui.sh
scripts/build_se_ui.sh
```
