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

## Credentials

The only credential used by this app is secret_key_base. Before using the application you should generate credentials with:
- EDITOR=vim rails credentials:edit

You can change to whatever editor you like more. If you use vim, you can exit with "ESC :wq" keys combination. You are wellcome.
Save and exit. You will have /config/master.key and /config/credentials.yml.enc generated for your project. Don't share master.key. 

## Deploying

You can build a container to deploy the app running this command:

- ```docker build --build-arg RAILS_MASTER_KEY=[your master.key contents] --tag calculadora_judicial . ```

To test the container localy: 

- ```docker run --rm --publish 80:80 --name calculadora_judicial calculadora_judicial```

Change ```--publish 80:80``` to ```--publish [YOUR MACHINE PORT NUMBER]:80``` to publish the app in a different port.

You can open a shell into the container appening "sh" after that order. In that case, the app won't launch: you can launch it running ```nginx && bundle exec rails s``` (the CMD order of the Dockerfile) Of course you can use all docker utilities like exec, start, etc. to manage that container. Change ```config.consider_all_requests_local``` in ```/config/environments/production``` inside the container if you want to see error outputs.

The container uses nginx as a reverse proxy for the application and also to serve static files. It runs using sqlite3 as database. Be aware that it should work as a read-only database in production: after data is seeded you don't need to change anything. If data changes you can redeploy the container. 

It should be easy to write a Dockerfile to use a postrgresql server from the Dockerfile provided.

## Import data

You can import the data structure and holidays for Spain runing ```rails db:seed```. That task will delete all existing estructure and recreate it again.

### Territories

There are two rake tasks to load territories:
- ```rails import:structure``` will delete all territories (and holidays) and create the territories structure: country, autonomous_community, island and region. 

Islands and regions are used because some autonomous communities have different holidays for parts of it.

- ```rails import:municipalities``` will delete all municipalities and local entities (and associated holidays) and create them again. Local entities are parts of a municipality which can have different holidays.

The csv with the data was last updated in 2020. It don't change often (but it changes)

### Holidays

Holiday's files are stored in ```data/holidays``` directory. There is a subdirectory for each year. They are loaded with ```rails db:seed```.

There is a rake tasks to load holidays:
- ```rails import:holiday YEAR=2020``` will delete all 2020's holidays and create them again for that year. You can use ```YEAR=All``` to process all files.

## Development

### Requirements

For development you can work with sqlite3. If you want to use it, just uncomment the corresponding lines on .env file.

You can also run this project with a postgressql server. There is a docker-compose-yml file if you want to use it; in that case you will only need to have docker and docker-compose installed in your system. Just run ```docker-compose up``` and you should have a postgresql server available for the project.

You will need to install libpq-dev for building pg gem to run the project localy.

#### Preparing

There are a .ruby-version and .ruby-gemset files in case you want to use rvm. If you are using a gem manager you won't need to prefix commands with ```bundle exec``` when required.

1) As usual, you must install gems and packages before using the app for the first time and each time you change gems or packages
    - ```bundle install```
    - ```yarn install --check-files```

    You can run both commands in parallel to save time, some gems and packages take a long time to compile.

2) After that you should configure the databases you will be using for tests and development. If you plan to use the provided docker container to run the database it's enough to copy .env.example file to .env. If not, change .env file with your configuration:
    - ```cp .env.example .env```

3) Then you must start the database server:
    - ```docker-compose up database -d```

    You can remove the -d flag if you want to see container's output

4) Then run the migrations: 
    - ```rails db:migrate```

4) And maybe you want to import data: 
    - ```rails db:seed```

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