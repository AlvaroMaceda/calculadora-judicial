#!/bin/sh
set -e
echo "Current dir: `pwd`"
echo "User: `id`"

for i in $*; do 
   echo $i 
done

if [ "$#" -eq 0 ]; then
    echo "Running overmind..."
    rm ./.overmind_docker.sock || true
    rm /app/tmp/pids/server.pid || true
    overmind start
else
    echo "Arguments passed, \'runing bundle exec $*\'"
    bundle exec $*
fi