#!/bin/bash

# For debugging
# echo $*

# export UID=${UID}
# export GID=${GID}

export USER_ID=$(id -u ${USER})
export GROUP_ID=$(id -g ${USER})




# Usage:
# - Use 'build' for building the container: ./app.sh build
# - Call it withouth parameters to run the app: ./app.sh
# - Call it with a command to execute it with bundle exec: ./app.sh rspec
# - Add 'exec' for executing an arbitrary command into the container: ./app.sh exec bundle install
# - You can use 'exec' to open a shell into the container: ./app.sh exec sh

case $1 in
    build)
        echo 'Building container...'
        docker-compose \
            -f ./docker/docker-compose.yml \
        build \
            --build-arg USER_ID=$USER_ID \
            --build-arg GROUP_ID=$GROUP_ID
        ;;

    stop)
        echo 'Stopping container...'
        docker-compose -f ./docker/docker-compose.yml stop
        ;;

    down)
        echo 'Destroying container...'
        shift
        docker-compose -f ./docker/docker-compose.yml down $*
        ;;

    exec)
        echo "Executing command in the container..."
        shift
        docker-compose -f ./docker/docker-compose.yml run --rm --entrypoint '""' app $*
        ;;

    "")
        echo 'Starting the app...'
        docker-compose -f ./docker/docker-compose.yml up app database
        ;;

    *)
        echo 'Executing command in the container with bundle exec...'
        docker-compose -f ./docker/docker-compose.yml run --rm app $*
        ;;

esac