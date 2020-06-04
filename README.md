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

You can also import 

### Holidays

Holiday's files are stored in ```data/holidays``` directory. There is a subdirectory for each year. They are loaded with ```rails db:seed```.

There is a rake tasks to load holidays:
- ```rails import:holiday ENV=2020``` will delete all 2020's holidays and create them again for that year. You can use ```ENV=All``` to process all files.

## Development

### Running the app with Docker
You must install gems and packages before using the app for the first time and each time you change gems or packages. gems and packages are installed into a container's volume, so you won't need to do it again if you don't destroy the volumes:
docker-compose run --rm --entrypoint "" app bundle install
docker-compose run --rm --entrypoint "" app yarn install --check-files

Also you will need to run migrations:
docker-compose run --rm app rails db:migrate

And perhaps import data:
docker-compose run --rm app rails db:seed

After that you can start the application. It doesn't use overmind yet:
docker-compose up

You can use -d option if you don't want to see output:
docker-compose up -d

To stop the application: CTRL+C or:
docker-compose stop

To completely remove the application and volumes:
docker-compose down -v

To run tasks into the container (if you don't override entrypoint they will be ran with 'bundle exec'):
docker-compose run --rm app rake test

To open a shell on rails container:
docker-compose run --rm --entrypoint "" app bash



### Requirements

TODO: sqlite3 is obsolete

- sqlite3
- sqlite3-pcre (for regular expressions in sqlite3)

You should put this line into your ~/.sqliterc to load sqlite3-prc if you want to tests the querys using command-line sqlite3:
```.load /usr/lib/sqlite3/pcre.so```

Or you can load it in each statement:
```sqlite3 test.sqlite3 -cmd ".load /usr/lib/sqlite3/pcre.so" "SELECT * FROM municipalities WHERE name REGEXP '.*al.*';"```

### Preparing

If you are using rvm, enter the project gemset with ```rvm use .```
The first time you should install dependencies with ```bundle install```

### Launch server

Use ```rails server``` to launch the project in development mode. You can speed javascript and css reloading launching webpack in another shell: ```./bin/webpack-dev-server```

The project will be available at http://localhost:3000

Alternatively, you can use [overmind](https://github.com/DarthSim/overmind). Install it and run ```overmind start```

### Launch test
You can run tests with ```rspec``` or watch for changes using ```guard```
