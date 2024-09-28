# USFWS SECAS Southeast Conservation Blueprint Explorer & Southeast Species Status Landscape Assessment Tool Deployment Configuration

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

These projects are deployed for testing and public use on the U.S. Fish and
Wildlife Service Azure environment managed by USFWS IRTM. See [Azure README](./Azure.md)
for more information.
