# Local Development

This environment is intended to be used for local development and testing of
the docker containers.

An `.env` file in this folder contains the following variables:

```
COMPOSE_PROJECT_NAME=secas
BLUEPRINT_CODE_DIR=<location of secas-blueprint repo>
SSA_CODE_DIR=<location of secas-ssa repo>
MAPBOX_ACCESS_TOKEN=<token>
API_TOKEN=<token>
API_SECRET=<secret>
LOGGING_LEVEL=DEBUG
REDIS_HOST=redis
SENTRY_ENV="development"
ROOT_URL=<host URL>
HOST_TILE_DIR=<location of tiles on host>
BLUEPRINT_STATIC_DIR=/var/www/southeastblueprint
SSA_STATIC_DIR=/var/www/southeastssa
```

Source this file in your shell `source .env`.
(in Fish shell: `export (grep "^[^#]" .env |xargs -L 1)`)

The UI static assets are built using by running the following `gatsby clean` and
`gatsby build` in the `ui` folder of each application repository, and copying the
outputs in the `public` directory to `var/www/southeastblueprint` and
`/var/www/southeastssa`.

After those have been built, pull the other images and run:

```bash
docker-compose pull
docker-compose up -d
```
