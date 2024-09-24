# API and Background Worker Dockerfile

This Dockerfile provides the runtime environment for both the Southeast
Blueprint Explorer and Southeast Species Status Landscape Assessment Tool
API and Background Worker services:

-   `se-api`
-   `se-worker`
-   `ssa-api`
-   `ssa-worker`

All share the same Python dependencies.

Note: two applications use different font stacks, so both sets of fonts are
installed into this image.
