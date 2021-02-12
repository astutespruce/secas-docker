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
MBGL_SERVER_URL=http://renderer/render
SENTRY_ENV="development"
SA_SITE_URL=http://localhost:8080/southatlantic
SE_SITE_URL=http://localhost:8080/southeast
```

It may also include version overrides of the Docker image versions specified
in the root `public-images` file, for use in local testing before deployment.

Source this file in your shell `source .env`.
(in Fish shell: `export (grep "^[^#]" .env |xargs -L 1)`)

```bash
docker-compose pull
docker-compose build sa-api sa-worker
```
