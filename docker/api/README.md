# API and Background Worker Dockerfile

This Dockerfile provides the runtime environment for both the Southeast and
South Atlantic API and Background Worker services:

-   `se-api`
-   `se-worker`
-   `sa-api`
-   `sa-worker`

All share the same Python dependencies.

Note: two applications use different font stacks, so both sets of fonts are
installed into this image.
