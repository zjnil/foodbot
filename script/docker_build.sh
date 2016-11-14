#!/bin/bash

docker run --rm -it -v "$(pwd)":/app -w /app elixir:1.3 bash -c "
  mix local.hex --force &&
  MIX_ENV=prod mix compile &&
  MIX_ENV=prod mix release --env=prod
"
