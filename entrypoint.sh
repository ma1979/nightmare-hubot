#!/usr/bin/env bash
set -e

# Start Xvfb
Xvfb :1 -screen 0 1024x768x24 > /dev/null &
export DISPLAY=:1

exec "$@"