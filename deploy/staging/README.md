# Deployment to staging environment

The Azure instance can only be accessed via SSH within the DOI network. All
access to the DOI network now requires a government furnished computer (GFE, below)
that is on the GlobalProtect VPN. SSH is accessed via PowerShell.

Use `ssh <hostname> -l <username without domain>`

IMPORTANT: unless otherwise noted, everything is run as `app` user, make sure to
run the following each time you SSH into this instance (after setting up the
user account below).

```bash
sudo su app
```

## Instance setup

The base instance is provided on the USFWS Azure environment by USFWS IRTM staff
according to specifications defined separately. This guide covers setup of the
services used by the application.

### Install basic tools

```bash
sudo dnf --refresh update
sudo dnf install -y epel-release
sudo dnf install -y git vim p7zip p7zip-plugins
```

### Create swap space

```bash
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

Add this to `/etc/fstab`: `/swapfile none swap sw 0 0`

### Initialize data volume

The instance has a 128 GB volume provided by IRTM staff during setup. This needs
to be initialized and mounted:

se `lsblk` to list volumes; it may be listed as `sdb`

```bash
sudo mkfs -t ext4 /dev/sdb
sudo mkdir /data
sudo mount /dev/sdb /data
```

Add this to `/etc/fstab`: `/dev/sdb /data ext4 defaults,nofail`

### Install docker compose

```bash

sudo dnf install yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
```

Verify docker daemon is now running:

```bash
sudo systemctl status docker
```

### Create user and transfer ownership of main directories:

```bash
sudo groupadd --gid 1010 app
sudo useradd --uid 1010 --gid app --shell /bin/bash --create-home app
sudo usermod -aG docker app
sudo mkdir /var/www
sudo chown app:app /var/www
sudo chown app:app /data
```

Add current domain user to `app` group:

```bash
sudo usermod -aG app <domain user>
```

as `app` user:

create an alias for docker-compose by adding `alias docker-compose="docker compose"`
to `~/.bash_profile`.
(NOTE: this is only needed for muscle-memory; everything can use `docker compose` instead)

Setup directories and pull repositories (note the `-test` suffix for `/var/www` folders are just for staging):

```bash
mkdir /var/www/test-southeastblueprint
mkdir /var/www/test-southeastssa
mkdir /data/se
mkdir /data/tiles
cd ~
git clone https://github.com/astutespruce/secas-docker.git
git clone https://github.com/astutespruce/secas-blueprint.git
git clone https://github.com/astutespruce/secas-ssa.git
```

NOTE: only create `/data/*` folders if they don't already exist on the attached EFS data volume.

### Environment setup

#### Setup Docker environment variables

Set up an environment file at `~/secas-docker/deploy/staging/.env`:

```
COMPOSE_PROJECT_NAME=secas
MAPBOX_ACCESS_TOKEN=<token>
API_TOKEN=<token>
API_SECRET=<secret>
LOGGING_LEVEL=INFO
REDIS_HOST=redis
SENTRY_DSN=<DSN>
SENTRY_ENV=azure-staging
ROOT_URL=https://apps.fws.gov/test-southeastblueprint
ALLOWED_ORIGINS=https://apps.fws.gov
MAP_RENDER_THREADS=4
MAX_JOBS=4
CUSTOM_REPORT_MAX_ACRES=50000000

TILE_DIR=/data/tiles
BLUEPRINT_CODE_DIR=/home/app/secas-blueprint
BLUEPRINT_DATA_DIR=/data/se
BLUEPRINT_STATIC_DIR=/var/www/southeastblueprint
SSA_CODE_DIR=/home/app/secas-ssa
SSA_STATIC_DIR=/var/www/southeastssa
```

IMPORTANT: This file must be sourced to perform any Docker operations.

```bash
set -a
source ~/secas-docker/deploy/staging/.env
```

#### Setup user interface environment variables

Create `~/secas-blueprint/ui/.env.production` with the following:

```bash
PUBLIC_MAPBOX_TOKEN=<token>
PUBLIC_API_TOKEN=<token>
PUBLIC_SENTRY_DSN=<DSN>
PUBLIC_GOOGLE_ANALYTICS_ID=<id>
PUBLIC_CONTACT_EMAIL=<contact email>

# show warning in UI when on staging server
PUBLIC_DEPLOY_ENV="staging"

# specific to domain where this is deployed
DEPLOY_PATH=/test-southeastblueprint
PUBLIC_API_HOST=<API host>/test-southeastblueprint
PUBLIC_TILE_HOST=<tile host>/test-southeastblueprint
```

Create `~/secas-ssa/ui/.env.production` with the following:

```bash
GATSBY_SENTRY_DSN=<dsn>
GATSBY_GOOGLE_ANALYTICS_ID=<id>
GATSBY_API_TOKEN=<api token>

SITE_ROOT_PATH=test-southeastssa
SITE_URL=<root URL>/test-southeastssa
GATSBY_API_HOST=<root URL>/test-southeastssa

# show warning in UI when on staging server
GATSBY_ENV="staging
```

## Upload data

Use 7zip to zip the following directories in the `secas-blueprint` project:

-   `data/inputs`
-   `data/results`
-   `tiles`

and the following in the `secas-ssa` project:

-   `data/inputs`

Upload these to the USFWS FileShare, and then download from there to the
instance as the `app` user:

```bash
cd /data/se
curl -L -o inputs.7z <URL on fileshare>
7z e -spf inputs.7z
curl -L -o results.7z <URL on fileshare>
7z e -spf results.7z
curl -L -o inputs-ssa.7z <URL on fileshare>
7z e -spf inputs-ssa.7z
cd /data
curl -L -o tiles.7z <URL on fileshare>
7z e -spf tiles.7z
```

IMPORTANT: replace `/s/` in the URL generated by USFWS FileShare with `/shared/static`
or go into Link Settings when creating the download URL for the item in USFWS
FileShare and copy the Direct Link at the bottom.

Note: do this in a separate folder and move files if the above directories already
exist and data files have previously been downloaded to the server.

After upload, change permissions using the default user when you SSH to the
server (not the `app` user):

```
sudo chown -R app:app /data
```

## Setup internal TLS certificates

Each instance must be issued an internal TLS certificate used for the route from
the WAF to the instance; these are deployed within Caddy.

See general DOI certificate request instructions [here](https://doimspp.sharepoint.com/sites/ocio-ecm-csr).

On the instance as the `app` user, create the certificate signing request and key:

```bash
cd ~/secas-docker/deploy/staging
mkdir certificates
cd certificates
openssl req -nodes -newkey rsa:2048 -keyout internal-tls.key -out internal-tls.csr
```

Then fill out as follows:

-   Country Name: US
-   State or Province Name: North Carolina
-   Locality name: Raleigh
-   Organization Name: Department of Interior
-   Organizational Unit Name: Fish and Wildlife Service
-   Common Name: <full hostname> (e.g., <host>.fws.doi.net)
-   Email address: <user's FWS email address>

Then copy the contents of the CSR (select and right click):

```bash
cat internal-tls.csr
```

On a GFE, follow the [instructions](https://doimspp.sharepoint.com/sites/ocio-ecm-csr)
in Microsoft Edge. Then open the DOI certificate request page in Internet
Explorer mode (first load the page, then use the ... menu in upper right and
reload in Internet Explorer mode).

Then choose to submit a request using a base-64-encoded CMC, and paste in the contents
of the CSR copied above.

Add the following to additional attributes

```
san:dns="<full hostname>"
&dns=<full hostname>
```

Once the certificate has been granted (typically a few minutes), in Internet Explorer
follow the link to the status of a pending certificate request. Choose Base64
encoding and download the certificate as `certnew.cer` and download the CA
certificate chain as `certnew.p7b`..

Open a new PowerShell window on the GFE, navigate to the `Downloads` folder,
and copy the contents of `certnew.cer`:

```bash
cat certnew.cer | clip
```

In the SSH window (as `app`) on the instance, create `internal-tls-leaf.pem`
(in the `deploy/staging/certificates` folder) and paste the contents of the
certificate into it .

Copy the contents of `certnew.p7b`:

```bash
cat certnew.p7b | clip
```

In the SSH window (as `app`) on the instance, create a file `ca.p7b`
(in the `deploy/staging/certificates` folder) and paste the contents of the
certificate chain into it.

Then convert the CA certificate chain (on the instance):

```bash
openssl pkcs7 -print_certs -in ca.p7b -out ca.pem
```

And merge together to create certificate chain:

```bash
cat internal-tls-leaf.pem ca.pem > internal-tls.pem
```

Update permissions

```bash
chmod 600 internal-tls.key
chmod 600 internal-tls.pem
```

Verify the issued certificate

```bash
openssl verify -verbose -CAfile ca.pem internal-tls.pem
```

That should print out `OK` on success. These will be automatically used once
the Caddy Docker service starts below.

## Update Docker images on the server

Pull images in this folder:

```bash
cd ~/secas-docker/deploy/staging
set -a
source .env
docker compose pull
```

Then bring the services up:

```bash
docker compose up -d
```

Make sure that each service started and is healthy.

```bash
docker compose ps
```

should show that `State` is `Up` for each of the Docker containers.

If there are problems, you can use

```bash
docker compose logs --tail 100 <service>
```

## Update user interface code and build it

The UI needs to be rebuilt anytime there is an update to the user interface
code for either of the applications. The build step automatically updates the
environment to use the Javascript package versions specified in the
`package-lock.json` files in each app's `ui` folder.

If needed, pull the latest UI build image from the root of this repository:

```bash
cd ~/secas-docker
docker compose -f docker/ui/docker-compose.yml pull
```

### Southeast Blueprint Explorer

To rebuild the frontend for the Southeast Blueprint Explorer:

```bash
cd ~/secas-blueprint
git pull origin
cd ~/secas-docker
set -a
source ~/secas-docker/deploy/staging/.env
scripts/build_se_ui.sh
```

### Species Landscape Status Assessment Tool

To rebuild the frontend for the Species Landscape Status Assessment Tool:

```bash
cd ~/secas-ssa
git pull origin
cd ~/secas-docker
set -a
source ~/secas-docker/deploy/staging/.env
scripts/build_ssa_ui.sh
```

## Update API / backend code

### Southeast Blueprint Explorer

To update API / backend code for the Southeast Blueprint Explorer:

```bash
cd ~/secas-blueprint
git pull origin
cd ~/secas-docker/deploy/staging
set -a
source .env
docker compose restart se-worker se-api
```

Then verify the services came up properly:

```bash
docker compose logs --tail se-worker
docker compose logs --tail se-api
```

### Species Landscape Status Assessment Tool

To update API / backend code for the Species Landscape Status Assessment Tool:

```bash
cd ~/secas-ssa
git pull origin
cd ~/secas-docker/deploy/staging
set -a
source .env
docker compose restart ssa-worker ssa-api
```

Then verify the services came up properly:

```bash
docker compose logs --tail ssa-worker
docker compose logs --tail ssa-api
```

## Verify apps are now reachable internally

On the instance:

```bash
curl -k -v https://ifwaz-sebp-test.fws.doi.net/test-southeastblueprint
curl -k -b https://ifwaz-sebp-test.fws.doi.net/test-southeastblueprint
```

## Notify IRTM to setup Azure App Gateway

Azure staff create an App Gateway that points to this server based on a domain
name / URL they provide. Once that is setup, the applications are available at:

-   https://apps.fws.gov/test-southeastblueprint
-   https://apps.fws.gov/test-southeastssa
