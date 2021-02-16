# Local Development

This environment is intended to be used against public images available on
Docker Hub (not necessarily pushed to GeoPlatform yet) and Docker images
build locally for the API and Worker services.

An `.env` file in this folder contains the following variables:

```
COMPOSE_PROJECT_NAME=secas
SA_DIR=<location of sa-blueprint-sv repo>
SE_DIR=<location of secas-blueprint repo>
MAPBOX_ACCESS_TOKEN=<token>
API_TOKEN=<token>
API_SECRET=<secret>
LOGGING_LEVEL=DEBUG
REDIS_HOST=redis
MBGLRENDER_HOST=renderer
SENTRY_ENV="development"
SA_SITE_URL=<host>/southatlantic
SE_SITE_URL=<host>/southeast
```

Source this file in your shell `source .env`.
(in Fish shell: `export (grep "^[^#]" .env |xargs -L 1)`)

The API and UI Docker images are built using `scripts/build_custom_images.sh`.

The UI static assets are built using `scripts/build_sa_ui.sh` and
`scripts_build_se_ui.sh`.

After those have been built, pull the other images and run:

```bash
docker-compose pull
docker-compose up -d
```
