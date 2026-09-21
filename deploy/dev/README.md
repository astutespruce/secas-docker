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

# NOTE: only used for midwest until migrated to PMTiles
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

See [staging README](../staging/README.md) for `.env.production` file settings.

After those have been built, pull the other images and run:

```bash
docker-compose pull
docker-compose up -d
```

### UI Build

Caddy is mounted directly to the build output directory (`ui/public`) created by
Vite from running `npm run build` in the `ui` folder of each application repository.

WARNING: running `npm run build` deletes and recreates that directory, which
breaks the connection from Docker. You have to run
`docker compose down caddy && docker compose up -d caddy` to remount it.
