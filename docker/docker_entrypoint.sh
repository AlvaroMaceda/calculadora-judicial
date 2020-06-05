#!/bin/sh
set -e

if [ "$#" -eq 0 ]; then
    echo "Running overmind..."
    rm ./.overmind_docker.sock || true
    rm /app/tmp/pids/server.pid || true
    overmind start
else
    echo "Rruning bundle exec $*"
    bundle exec $*
fi