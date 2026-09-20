# Local Development

This environment is intended to be used for local development and testing of
the Docker containers.

An `.env` file in this folder contains the following variables:

```
COMPOSE_PROJECT_NAME=secas
SOUTHEAST_BLUEPRINT_CODE_DIR=<location of secas-blueprint repo>
SOUTHEAST_BLUEPRINT_DATA_DIR=<location of data folder in secas-blueprint local directory>
SOUTHEAST_BLUEPRINT_STATIC_DIR=<location of secas-blueprint repo followed by /ui/public>
SOUTHEAST_BLUEPRINT_TILES_DIR=<location of directory containing pmtiles files>

SSA_CODE_DIR=<location of secas-ssa repo>
SSA_DATA_DIR=<location of data folder in secas-ssa local directory>
SSA_STATIC_DIR=<location of secas-ssa repo followed by /ui/public>

MIDWEST_BLUEPRINT_CODE_DIR=<location of mli-blueprint repo>
MIDWEST_BLUEPRINT_DATA_DIR=<location of data folder in mli-blueprint local directory>
MIDWEST_SOUTHEAST_BLUEPRINT_STATIC_DIR=<location of mli-blueprint repo followed by /ui/public>

HOST_TILE_DIR=<location of tiles on host>

MAPBOX_ACCESS_TOKEN=<token>
API_TOKEN=<token>
API_SECRET=<secret>
LOGGING_LEVEL=DEBUG
REDIS_HOST=redis
SENTRY_ENV="development"
ROOT_URL=<host URL>
```

Source this file in your shell `source .env`.
(in Fish shell: `export (grep "^[^#]" .env |xargs -L 1)`)

The UI static assets are built using by running `npm run build` in the `ui`
folder of each application repository. NOTE: you need to stop caddy before
running the build step because it prevents NodeJS from removing the `public`
directory in each application.

See [staging README](../staging/README.md) for `.env.production` file settings.

After those have been built, pull the other images and run:

```bash
docker-compose pull
docker-compose up -d
```
