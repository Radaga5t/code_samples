#!/bin/bash

set -e
bundle config without development:test
bundle check || bundle install --binstubs="$BUNDLE_BIN"

exec "$@"
