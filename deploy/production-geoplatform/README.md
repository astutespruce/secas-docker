# Deployment to production environment

IMPORTANT: unless otherwise noted, everything is run as `app` user, make sure to
run the following each time you SSH into this instance (after setting up the
user account below).

```bash
sudo su app
```

## Instance setup

The base instance is provided by Zivaro according to specifications defined
separately. This guide covers setup of the services used by the application.

Upgrade `docker-compose`:

1. uninstall installation via `apt-get`: `sudo apt-get remove docker-compose`
2. Install using `curl` using link on docker-compose website.

### Create user and transfer ownership of main directories:

NOTE: user / group must be set to 1010 for permissions to work properly with UI build container

```bash
sudo groupadd --gid 1010 app
sudo useradd --uid 1010 --gid app --shell /bin/bash --create-home app

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
mkdir /var/www/southeastblueprint
mkdir /var/www/southeastssa
mkdir /data/se
mkdir /data/tiles
cd ~
git clone https://github.com/astutespruce/secas-docker.git
git clone https://github.com/astutespruce/secas-blueprint.git
git clone https://github.com/astutespruce/secas-ssa.git
```

### Environment setup

#### Setup Docker environment variables

Set up an environment file at `~/secas-docker/deploy/production/.env`:

```
COMPOSE_PROJECT_NAME=secas
DOCKER_REGISTRY=<registry>
MAPBOX_ACCESS_TOKEN=<token>
API_TOKEN=<token>
API_SECRET=<secret>
LOGGING_LEVEL=INFO
REDIS_HOST=redis
SENTRY_DSN=<DSN>
SENTRY_ENV=azure-production
ROOT_URL=https://blueprint.geoplatform.gov
ALLOWED_ORIGINS=https://blueprint.geoplatform.gov
MAP_RENDER_THREADS=4
MAX_JOBS=4
CUSTOM_REPORT_MAX_ACRES=50000000

TILE_DIR=/data/tiles
BLUEPRINT_CODE_DIR=/home/app/secas-blueprint
SSA_CODE_DIR=/home/app/secas-ssa
BLUEPRINT_DATA_DIR=/data/se
BLUEPRINT_STATIC_DIR=/var/www/southeastblueprint
SSA_STATIC_DIR=/var/www/southeastssa

CADDY=<caddy version>
REDIS=<redis version>
MBTILESERVER=<mbtileserver version>
```

IMPORTANT: This file must be sourced to perform any Docker operations.

You can use `scripts/set_env.sh` to set these variables:

```bash
ENV=production scripts/set_env.sh
```

If that doesn't work:

```bash
set -a
source ~/secas-docker/deploy/production/.env
```

#### Setup user interface environment variables

Create `~/secas-blueprint/ui/.env.production` with the following:

```bash
GATSBY_MAPBOX_API_TOKEN=<mapbox token>
GATSBY_API_TOKEN=<api token>

SITE_ROOT_PATH=southeast
SITE_URL=https://blueprint.geoplatform.gov/southeast
GATSBY_API_HOST=https://blueprint.geoplatform.gov/southeast
GATSBY_TILE_HOST=https://blueprint.geoplatform.gov

GATSBY_SENTRY_DSN=<dsn>
GATSBY_GOOGLE_ANALYTICS_ID=<id>
```

Create `~/secas-ssa/ui/.env.production` with the following:

```bash
GATSBY_MAPBOX_API_TOKEN=<mapbox token>
GATSBY_API_TOKEN=<api token>

SITE_ROOT_PATH=ssa
SITE_URL=https://blueprint.geoplatform.gov/ssa
GATSBY_API_HOST=https://blueprint.geoplatform.gov/ssa

GATSBY_SENTRY_DSN=<dsn>
GATSBY_GOOGLE_ANALYTICS_ID=<id>
```

## Upload data

Tiles and data files are loaded up to the test environment first, and then
synced by Zivaro staff to the production instance when they have been proofed
(using a Rundeck script in their AWS orchestration suite). Put in a support
ticket as specified above to request sync of data from test environment to
production.

After transfer of data to EFS mounted at `/data`, change permissions using the
default user when you SSH to the server (not the `app` user):

```
sudo chown -R app:app /data
```

## Update Docker images on the server

Create Docker token:

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $DOCKER_REGISTRY
```

NOTE: this is a slight variant of the procedure in `GeoPlatform.md` for locally
setting this token since it behaves differently on the instance due to using
SSH.

Pull images in this folder:

```bash
cd ~/secas-docker/deploy/production
docker-compose pull
```

Then bring the services up:

```bash
docker-compose up -d
```

Make sure that each service started and is healthy.

```bash
docker-compose ps
```

should show that `State` is `Up` for each of the Docker containers.

If there are problems, you can use

```bash
docker-compose logs --tail 100 <service>
```

## Update API / backend code

### Southeast Blueprint Explorer

To update API / backend code for the Southeast Blueprint Explorer:

```bash
cd ~/secas-blueprint
git pull origin
cd ~/secas-docker/deploy/production
set -a
source .env
docker-compose restart se-worker se-api
```

Then verify the services came up properly:

```bash
docker-compose logs --tail se-worker
docker-compose logs --tail se-api
```

### Species Landscape Status Assessment Tool

To update API / backend code for the Species Landscape Status Assessment Tool:

```bash
cd ~/secas-ssa
git pull origin
cd ~/secas-docker/deploy/production
set -a
source .env
docker-compose restart ssa-worker ssa-api
```

Then verify the services came up properly:

```bash
docker-compose logs --tail ssa-worker
docker-compose logs --tail ssa-api
```

## Update user interface code and build it

The UI needs to be rebuilt anytime there is an update to the user interface
code for either of the applications. The build step automatically updates the
environment to use the Javascript package versions specified in the
`package-lock.json` files in each app's `ui` folder.

If needed, pull the latest UI build image from the root of this repository:

```bash
cd ~/secas-docker
docker-compose -f docker/ui/docker-compose.yml pull
```

### Southeast Blueprint Explorer

To rebuild the frontend for the Southeast Blueprint Explorer:

```bash
cd ~/secas-blueprint
git pull origin
cd ~/secas-docker
set -a
source ~/secas-docker/deploy/production/.env
scripts/build_se_ui.sh
```

### Species Landscape Status Assessment Tool

To rebuild the frontend for the Species Landscape Status Assessment Tool:

```bash
cd ~/secas-ssa
git pull origin
cd ~/secas-docker
set -a
source ~/secas-docker/deploy/production/.env
scripts/build_ssa_ui.sh
```

## Verify applications are operating properly

Go to the following URLs and verify that they are online and functioning
properly:

-   https://blueprint.geoplatform.gov/southeast/
-   https://blueprint.geoplatform.gov/ssa/
