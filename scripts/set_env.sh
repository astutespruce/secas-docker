#!/bin/bash -u

# load environment variables into global scope

set -a
source deploy/$ENV/.env
set +a