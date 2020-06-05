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

You can develop this project using docker or rvm, as you prefer. These instructions refer to the docker.

#### Preparing
First you must build the container with:
- ./app.sh build
- ```docker-compose -f ./docker/docker-compose.yml build```

You must install gems and packages before using the app for the first time and each time you change gems or packages. gems and packages are installed into a container's volume, so you won't need to do it again if you don't destroy the volumes:
- ./app.sh exec bundle install
- ./app.sh exec yarn install --check-files
- ```docker-compose -f ./docker/docker-compose.yml run --rm --entrypoint "" app bundle install```
- ```docker-compose -f ./docker/docker-compose.yml run --rm --entrypoint "" app yarn install --check-files```

Also you will need to run migrations: 
- ```docker-compose -f ./docker/docker-compose.yml run --rm app rails db:migrate```

And perhaps import data: 
- ```docker-compose -f ./docker/docker-compose.yml run --rm app rails db:seed```

You can import data later with rake tasks:
- ```docker-compose -f ./docker/docker-compose.yml run --rm app rake import:structure```
- ```docker-compose -f ./docker/docker-compose.yml run --rm app rake import:municipalities```
- ```docker-compose -f ./docker/docker-compose.yml run --rm app rake import:holidays```

### Launch server

After that you can start the application. It will start with overmind:
- ```docker-compose -f ./docker/docker-compose.yml up```

You can use -d option if you don't want to see output:
- ```docker-compose -f ./docker/docker-compose.yml up -d```

The project will be available at http://localhost:3000

To stop the application: 
- CTRL+C or ```docker-compose -f ./docker/docker-compose.yml stop```

### Launch test

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