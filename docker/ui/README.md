# User Interface Builder Docker files

These Dockerfiles provide the runtime environment for building the user
interface for the Southeast Blueprint Explorer and related applications.

These are built as static sites using SvelteJS and are hosted on the Caddy
reverse proxy service as static files.

Because each application may use slightly different Javascript dependencies,
each application has a separate Dockerfile.

The images are built using `scripts/build_custom_images.sh`.

The UI build steps are run using

- `scripts/build-se-ui.sh`
- `scripts/build-ssa-ui.sh`
- `scripts/build-midwest-ui.sh`

The UI build automatically fetches the dependencies defined in the `package.lock`
files for each application using `npm ci`.
