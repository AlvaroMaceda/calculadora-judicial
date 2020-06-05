# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Import data

### Territories

You can import the data structure for Spain runing ```rails db:seed```. That task will delete all existing estructure and recreate it again.

The csv with the data was last updated in 2020. It don't change often (but it changes)


### Holidays

Holiday's files are stored in ```data/holidays``` directory. There is a subdirectory for each year. They are loaded with ```rails db:seed```.

There is a rake tasks to load holidays:
- ```rails import:holiday ENV=2020``` will delete all 2020's holidays and create them again for that year. You can use ```ENV=All``` to process all files.

## Development

### Requirements

You can develop this project using docker or rvm, as you prefer. These instructions refer to the docker; to use rvm you only need to install it and execute ```rvm use .``` to activate the environment.

The container run as your host user and has complete sudo privileges, so proceed with caution if you mount a bind volume (you don't need to do that anyway)

#### Preparing

There is an script to help with application management: ```./app.sh```. That script will execute the appropiate docker-compose orders which could be very verbose. The corresponding docker-compose commands are listed after the app.sh commands.

The script works as follows: if called without parameters it will run the app. If it's called with ```exec SOME_ORDER``` will execute that order into the container. If it's called with ```SOME_ORDER``` it will execute ```bundle exec SOME_ORDER```.

To run the app you must follow these steps:

1) First you must build the container with:
    - ```./app.sh build```

    Equivalent docker-compose command: ```docker-compose -f ./docker/docker-compose.yml build```

2) You must install gems and packages before using the app for the first time and each time you change gems or packages. gems and packages are installed into a container's volume, so you won't need to do it again if you don't destroy the volumes:
    - ```./app.sh exec bundle install```
    - ```./app.sh exec yarn install --check-files```

    Equivalent docker-compose commands: 
    - ```docker-compose -f ./docker/docker-compose.yml run --rm --entrypoint "" app bundle install``` and 
    - ```docker-compose -f ./docker/docker-compose.yml run --rm --entrypoint "" app yarn install --check-files```

3) Also you will need to run migrations: 
    - ```./app.sh rails db:migrate```

    Equivalent docker-compose command: 
    - ```docker-compose -f ./docker/docker-compose.yml run --rm app rails db:migrate```

4) And perhaps import data: 
    - ```./app.sh rails db:seed```

    Equivalent docker-compose command: 
    - ```docker-compose -f ./docker/docker-compose.yml run --rm app rails db:seed```

    You can import data later with rake tasks:
    - ```./app.sh rake import:structure```
    - ```./app.sh rake import:municipalities```
    - ```./app.sh rake import:holidays```

    Equivalent docker-compose commands:
    - ```docker-compose -f ./docker/docker-compose.yml run --rm app rake import:structure```
    - ```docker-compose -f ./docker/docker-compose.yml run --rm app rake import:municipalities```
    - ```docker-compose -f ./docker/docker-compose.yml run --rm app rake import:holidays```

### Launch server

After following previous seteps you can start the application. It will start with overmind:
- ```./app.sh```

    Equivalent docker-compose command: ```docker-compose -f ./docker/docker-compose.yml up```

You can use -d option if you don't want to see output. In that case you will need to use docker-compose command directly:
- ```docker-compose -f ./docker/docker-compose.yml up -d```

The project will be available at http://localhost:3000

To stop the application: 
- CTRL+C or ```./app.sh stop```

    Equivalent docker-compose command: ```docker-compose -f ./docker/docker-compose.yml stop```

### Launch test
TO-DO

To run tests (don't forget the ./bin/ prefix):
- ```docker-compose -f ./docker/docker-compose.yml run --rm app ./bin/rspec```

You can use guard to watch for changes and run tests automatically:
- ```docker-compose run --rm app guard```

### Execute tasks in the container

To open a rails console:
- ```docker-compose -f ./docker/docker-compose.yml run --rm app rails console```

To open a shell on rails container:
- ```docker-compose -f ./docker/docker-compose.yml run --rm --entrypoint "" app bash```

To run tasks into the container (if you don't override entrypoint they will be ran with 'bundle exec'): 
- ```docker-compose -f ./docker/docker-compose.yml run --rm app rake whatever:task```

### Removing the containers

To completely remove the application and volumes: 
- ```docker-compose down -v```

### Connecting to the database

You can launch pgadmin4 to examinde the database:
- ```docker-compose -f docker-compose-pgadmin.yml up -d```

Then connect to pgadmin with your browser:
- http://localhost:8080 (User is "devuser", password "devuser")

It will ask for a password to connect to the database. Just hit enter.

To stop pgadmin4
- ```docker-compose -f ./docker/docker-compose-pgadmin.yml stop```

If you try to docker-compose down it will notify an error when it tries to delete the network because it's shared with rails application. There is no problem with that, the network will be removed when you run docker-compose down.

To completely remove pgadmin4:
- ```docker-compose -f ./docker/docker-compose-pgadmin.yml down -v```

Warning: it notifies that there are "orphans", but they are the rails and database container.