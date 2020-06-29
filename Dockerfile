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

# install rubygem

# bundle install --deployment

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
# RUN bin/rails assets:precompile

# Remove folders not needed in resulting image
RUN rm -rf node_modules tmp/cache app/assets vendor/assets spec tmp /db/*.sqlite3

############### Build step done ###############
FROM ruby:2.6.6-alpine
# Uncomment this if you want to 
# FROM build-container as deploy

# --------------------------------------------------------------------------------------------
# Rails
# --------------------------------------------------------------------------------------------
# If you touch RAILS_ROOT, remember to change it in webapp.conf file too
ARG RAILS_ROOT=/app
ARG RAILS_MASTER_KEY=
ENV PACKAGES="tzdata nodejs libxml2 libxslt"
ENV OPTIONAL_PACKAGES="bash"
# Change this is you are using postgress
ENV DATABASE_PACKAGES="sqlite sqlite-dev"

# Rails environmnet variables
ENV RAILS_ENV=production
ENV DATABASE_ADAPTER=sqlite3
ENV DATABASE_DATABASE_PRODUCTION=db/production.sqlite3
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

# Nginx configuration
COPY ./docker/webapp.conf /etc/nginx/sites-enabled/webapp.conf
# We must create this directory or override it at start time with nginx -g 'pid /tmp/nginx.pid;'
RUN mkdir /run/nginx

WORKDIR $RAILS_ROOT

# install packages
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $PACKAGES $OPTIONAL_PACKAGES $DATABASE_PACKAGES

RUN gem install bundler:2.1.4    

# ***Copy only necessary files
COPY --from=builder $RAILS_ROOT $RAILS_ROOT

# This is to see differences
ENV BANANA=/banana
COPY --from=builder $RAILS_ROOT/app $BANANA/app
COPY --from=builder $RAILS_ROOT/config $BANANA/config
COPY --from=builder $RAILS_ROOT/bin $BANANA/bin
COPY --from=builder $RAILS_ROOT/db $BANANA/db
COPY --from=builder $RAILS_ROOT/lib $BANANA/lib
COPY --from=builder $RAILS_ROOT/storage $BANANA/storage
COPY --from=builder $RAILS_ROOT/vendor $BANANA/vendor
COPY --from=builder $RAILS_ROOT/public $BANANA/public
COPY --from=builder $RAILS_ROOT/Gemfile $RAILS_ROOT/Gemfile.lock $BANANA/

# Database population
RUN bundle exec rails db:create db:migrate db:seed

EXPOSE 80

# multiple commands:
# https://docs.docker.com/config/containers/multi-service_container/
# CMD ["bin/rails", "server", "-b", "0.0.0.0"]
# CMD [ "sh", "-c", "bundle exec rake db:create db:migrate && bundle exec rails server -b 0.0.0.0" ]
CMD [ "sh", "-c", "bundle exec rails server -b 0.0.0.0" ]