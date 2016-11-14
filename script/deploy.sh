#!/bin/bash
set -e

SSH_SERVER="$1"
SSH_PATH="$2"

# upload release to server
scp "rel/$REL_NAME/releases/*/$REL_NAME.tar.gz" "$SSH_SERVER:/$SSH_PATH"

# extract and stop server (let the supervisor restart it)
ssh "$SSH_SERVER" <<ENDSSH
  cd "$SSH_PATH"
  tar xvf "$REL_NAME.tar.gz"
  "bin/$REL_NAME" stop
ENDSSH
