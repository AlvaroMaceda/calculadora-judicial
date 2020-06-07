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

To run this project you will need a postgressql server. There is a docker container created if you want to use it; in that case you will need to have docker and docker-compose installed in your system.

#### Preparing

There are a .ruby-version and .ruby-gemset files in case you want to use rvm. If you are using a gem manager you won't need to prefix commands with ```bundle exec``` when required.

1) As usual, you must install gems and packages before using the app for the first time and each time you change gems or packages
    - ```bundle install```
    - ```yarn install --check-files```

    you can run both commands in parallel to save time, some gems and packages take a long time to compile.

2) After that you should configure the databases you will be using for tests and development. If you plan to use the provided docker container to run the database it's enough to copy .env.example file to .env. If not, change .env file with your configuration:
    - ```cp .env.example .env```

3) Then you must start the database server:
    - ```docker-compose up database -d```

    You can remove the -d flag if you want to see container's output

4) Then run the migrations: 
    - ```rails db:migrate```

4) And maybe you want to import data: 
    - ```./app.sh rails db:seed```

    You can import data later with rake tasks:
    - ```rake import:structure```
    - ```rake import:municipalities```
    - ```rake import:holidays YEAR=all```

### Launch server

After following previous steps you can start the application. You can use [overmind](https://github.com/DarthSim/overmind) if you have it installed in your system:
- ```overmind start```

If not, you can launch rails directly with ```bundle exec rails server --port 3000``` and optionally you can launch webpack dev server concurrently to speed up development: ```./bin/webpack-dev-server```

The project will be available at http://localhost:3000

### Launch test

To run tests just:
- ```bundle exec ./bin/rspec```

You can use guard to watch for changes and run tests automatically:
- ```bundle exec guard```

### Removing the containers

To completely remove the containers and volumens:
- ```docker-compose down -v```

This will delete your application data (you should have it in csv files anyway)

### Connecting to the database

The database server is available at standard port 5432 on localhost. You can use whatever posgtresql client you want, but there is a container with pgadmin4 if you want to use it. 

You can launch pgadmin4 with:
- ```docker-compose up pgadmin -d```

Then connect to pgadmin with your browser:
- http://localhost:8080 (User is "devuser", password "devuser". If you know how to configure a pgadmin container without a password a pull request will be wellcomed)

It will ask for a password to connect to the database. Just hit enter.

Logs are disabled by default. If you need to see logs, comment the logging key for the service in docker-compose.yml.

To stop pgadmin4
- ```docker-compose stop pgadmin```

Alternatively you can just run ```docker-compose up -d``` when you launch the database server; this will start both the postgresql server and pgadmin.