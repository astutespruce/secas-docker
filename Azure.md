# USFWS Azure cloud-based environment setup

The USFWS Azure environment is setup under the control of USFWS IRTM. Developer
access requires a PIV credential and sign-in to VDI CloudDesktop in order to use
SSH to connect to the instances.

On that instance, enter the following into `.ssh/config`:

```
GSSAPIAuthentication yes
GSSAPIDelegateCredentials yes
```

Then connect to the server via SSH in PowerShell:

```bash
ssh -k ifwaz-sebp-<instance>
```

NOTE: this uses only the hostname, not the fully qualified domain name.

## File transfer

Data files and map tiles are uploaded to the USFWS FileShare (Box) account.
Permissions to use FileShare are granted in myaccount.fws.gov. Once those have
been secured, a folder is created under the user's account for file transfer for
the data files used by the application.

## Docker images

Base Docker images are either public (e.g., Redis) or created automatically by
Github actions in this repository.

## TLS Certificates

Each instance must be issued an internal TLS certificate used for the route from
the WAF to the reverse proxy.

Certificate request instructions [here](https://doimspp.sharepoint.com/sites/ocio-ecm-csr).
