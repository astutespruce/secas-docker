# USFWS SECAS Southeast Conservation Blueprint Explorer & Southeast Species Status Landscape Assessment Tool Deployment Configuration for GeoPlatform

This repository includes deployment configuration and instructions for deploying
the Southeast Conservation Blueprint Explorer and Southeast Species Status
Landscape Assessment Tool.

The code for those viewers are managed in separate repositories:

-   [Southeast Conservation Blueprint Explorer](https://github.com/astutespruce/secas-blueprint)
-   [Southeast Species Status Landscape Assessment Tool](https://github.com/astutespruce/secas-ssa)

These projects are deployed using Docker into different environments:

-   [local development](deploy/dev/README.md)
-   [staging](deploy/staging/README.md)
-   [production](deploy/production/README.md)

These projects are deployed for testing and public use on the U.S. Department
of Interior GeoPlatform, which is hosted on Amazon Web Services and managed by
[Zivaro](https://zivaro.com/). Docker images are built and pushed to the
Elastic Container Registry in GeoPlatform.

Please see [GeoPlatform operating instructions](GeoPlatform.md) for more
information about creating, tagging, pushing, and pulling Docker images in this
environment.
