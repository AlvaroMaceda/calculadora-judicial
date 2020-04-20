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

## Development

### Requirements
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
