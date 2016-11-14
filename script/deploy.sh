#!/bin/bash
set -e

REL_NAME="$1"
SSH_SERVER="$2"
DEPLOY_PATH="$3"

# get project version
VERSION=$(mix run -e "IO.puts(Mix.Project.config[:version])")

# upload release to server
scp rel/"$REL_NAME"/releases/"$VERSION"/"$REL_NAME.tar.gz" "$SSH_SERVER:/$DEPLOY_PATH"

# extract and stop server (let the supervisor restart it)
ssh "$SSH_SERVER" <<ENDSSH
  cd "$DEPLOY_PATH"
  tar xvf "$REL_NAME.tar.gz"
  "bin/$REL_NAME" stop
ENDSSH
