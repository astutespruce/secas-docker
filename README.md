# USFWS SECAS Southeast Conservation Blueprint Explorer & South Atlantic Conservation Blueprint Simple Viewer Deployment

This repository includes deployment configuration and instructions for deploying
the Southeast Conservation Blueprint Explorer and South Atlantic Conservation
Blueprint Simple Viewer.

The code for those viewers are managed in separate repositories:
* [Southeast Conservation Blueprint Explorer](https://github.com/astutespruce/secas-blueprint)
* [South Atlantic Conservation Blueprint Simple Viewer](https://github.com/astutespruce/sa-blueprint-sv)


These projects are deployed using Docker into different environments:
* [local development](deploy/dev/README.md)
* [staging (GeoPlatform)](deploy/staging/README.md)
* [production (GeoPlatform)](deploy/production/README.md)