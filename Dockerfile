# From https://medium.com/@lemuelbarango/ruby-on-rails-smaller-docker-images-bff240931332
FROM ruby:2.6.6-alpine AS builder

# This label is so we can prune the build images later with:
# docker image prune --filter label=stage=builder
LABEL stage=builder

ARG RAILS_ROOT=/app
ARG BUILD_PACKAGES="build-base curl-dev git libxml2 libxslt"
# For postgress
# ARG DEV_PACKAGES="postgresql-dev sqlite-dev yaml-dev zlib-dev nodejs yarn libxml2 libxslt"
# For sqlite3
# don't sure if libxml2 and libxslt goes in dev or in build packages
ARG DEV_PACKAGES="sqlite-dev yaml-dev zlib-dev nodejs yarn libxml2-dev libxslt-dev"
ARG RUBY_PACKAGES="tzdata"
ENV RAILS_ENV=production

ENV NODE_ENV=production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

WORKDIR $RAILS_ROOT
# install packages
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES

COPY Gemfile* package.json yarn.lock ./

RUN gem install bundler:2.1.4
COPY Gemfile Gemfile.lock $RAILS_ROOT/

#TO-DO: revise bundle configuration for production
RUN bundle config --global deployment true 
RUN bundle config --global frozen 1  \
    && bundle install --without development:test:assets -j4 --retry 3 --path=vendor/bundle

# Remove unneeded files (cached *.gem, *.o, *.c)
RUN rm -rf vendor/bundle/ruby/2.6.0/cache/*.gem \
    && find vendor/bundle/ruby/2.6.0/gems/ -name "*.c" -delete \
    && find vendor/bundle/ruby/2.6.0/gems/ -name "*.o" -delete

RUN yarn install --production
COPY . .
RUN bin/rails webpacker:compile

# Remove folders not needed in resulting image
# RUN rm -rf node_modules tmp/cache app/assets vendor/assets spec tmp /db/*.sqlite3

############### Build step done ###############
FROM ruby:2.6.6-alpine

# --------------------------------------------------------------------------------------------
# Rails
# --------------------------------------------------------------------------------------------
# If you touch RAILS_ROOT, remember to change it in webapp.conf file too
ARG RAILS_ROOT=/app
ARG RAILS_MASTER_KEY=
ENV PACKAGES="tzdata nodejs libxml2 libxslt nginx"
ENV OPTIONAL_PACKAGES="bash"
# Change this is you are using postgress
# sqlite-libs instead of sqlite-dev?
ENV DATABASE_PACKAGES="sqlite sqlite-dev"

# Nginx configuration
COPY ./docker/webapp.conf /etc/nginx/conf.d/default.conf
# We must create this directory or override it at start time with nginx -g 'pid /tmp/nginx.pid;'
RUN mkdir /run/nginx

WORKDIR $RAILS_ROOT

# install packages
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $PACKAGES $OPTIONAL_PACKAGES $DATABASE_PACKAGES

# Copy necesary files. Gems are in /vendor directory, no need to reinstall them
COPY --from=builder $RAILS_ROOT/config.ru $RAILS_ROOT/config.ru
COPY --from=builder $RAILS_ROOT/Rakefile $RAILS_ROOT/Rakefile
COPY --from=builder $RAILS_ROOT/Gemfile $RAILS_ROOT/Gemfile.lock $RAILS_ROOT/
COPY --from=builder $RAILS_ROOT/.bundle $RAILS_ROOT/.bundle
COPY --from=builder $RAILS_ROOT/app $RAILS_ROOT/app
COPY --from=builder $RAILS_ROOT/bin $RAILS_ROOT/bin
COPY --from=builder $RAILS_ROOT/config $RAILS_ROOT/config
COPY --from=builder $RAILS_ROOT/data $RAILS_ROOT/data
COPY --from=builder $RAILS_ROOT/db/seeds.rb $RAILS_ROOT/db/seeds.rb
COPY --from=builder $RAILS_ROOT/db/migrate $RAILS_ROOT/db/migrate
COPY --from=builder $RAILS_ROOT/lib $RAILS_ROOT/lib
COPY --from=builder $RAILS_ROOT/storage $RAILS_ROOT/storage
COPY --from=builder $RAILS_ROOT/vendor $RAILS_ROOT/vendor
COPY --from=builder $RAILS_ROOT/public $RAILS_ROOT/public

# Add user
RUN adduser rails_user -D --home /app

# Write permissions to app's directories
RUN chown -R rails_user.rails_user $RAILS_ROOT/db

# Switch to rails app user
USER rails_user
RUN gem install bundler:2.1.4 --user-install

# Rails environmnet variables
ENV RAILS_ENV=production
ENV DATABASE_ADAPTER=sqlite3
ENV DATABASE_DATABASE_PRODUCTION=db/production.sqlite3
ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

# Database population
RUN bundle exec rails db:create db:migrate db:seed

# We put here logs to stdout so we don't need to see all the import statements
ENV RAILS_LOG_TO_STDOUT=true

EXPOSE 80

USER root
# multiple commands:
# https://docs.docker.com/config/containers/multi-service_container/
# CMD ["bin/rails", "server", "-b", "0.0.0.0"]
# CMD [ "sh", "-c", "bundle exec rake db:create db:migrate && bundle exec rails server -b 0.0.0.0" ]
# TO-DO: control the two process running in the container
# CMD [ "sh", "-c", "nginx && bundle exec rails server -b 0.0.0.0" ]
CMD [ "sh", "-c", "nginx && su -c 'bundle exec rails s -b 0.0.0.0' rails_user" ]
