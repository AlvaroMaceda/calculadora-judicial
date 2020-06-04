#!/bin/bash
set -e

for i in $*; do 
   echo $i 
done

echo $# arguments 
if [ "$#" -eq 0 ]; then
    echo "Running overmind..."
    rm ./.overmind_docker.sock || true
    overmind start
else
    echo "Arguments passed, runing bundle exec $*"
    bundle exec $*
fi