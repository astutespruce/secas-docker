# South Atlantic Simple Viewer Deployment - DOI GeoPlatform - Production

This version is deployed to the DOI GeoPlatform infrastructure,
managed by Zivaro. This includes instructions for setting up the companion project
`secas-blueprint` since both use shared resources provided here.

Docker images are managed using AWS ECR service within the TEST account and shared
with the production account.

## Docker images

See `deploy/gpstaging/README.md` for information about creating and managing
docker images.

## Data

Tiles and data files are loaded up to the test environment first, and then synced by Zivaro staff to the production instance when they have been proofed (using a Rundeck script in their AWS orchestration suite). Put in a
support ticket as specified above to request sync of data from test environment to production.

After transfer of data to EFS mounted at `/data`, change permissions

```
sudo chown -R app:app /data
```

## Everything else

See [deploy/staging/README](../staging/README.md).
