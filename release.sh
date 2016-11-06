#!/bin/bash

docker run --rm -it -v $(pwd):/app elixir:1.3 bash -c 'export MIX_ENV=prod && cd /app && mix compile && mix release --env=prod'
