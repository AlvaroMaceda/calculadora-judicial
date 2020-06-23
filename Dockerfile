# From https://medium.com/@lemuelbarango/ruby-on-rails-smaller-docker-images-bff240931332
FROM ruby:2.6.3-alpine AS build-env

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

# for tz-data error
RUN bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java 

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
RUN bin/rails assets:precompile

# Remove folders not needed in resulting image
RUN rm -rf node_modules tmp/cache app/assets vendor/assets spec

############### Build step done ###############
FROM ruby:2.6.3-alpine

ARG RAILS_MASTER_KEY=
ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY

ARG RAILS_ROOT=/app
# ARG PACKAGES="tzdata postgresql-client nodejs bash"
ARG PACKAGES="tzdata sqlite sqlite-dev nodejs bash libxml2 libxslt"

ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

WORKDIR $RAILS_ROOT

# install packages
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $PACKAGES

RUN gem install bundler:2.1.4    

COPY --from=build-env $RAILS_ROOT $RAILS_ROOT

# Required by sprockets
COPY /app/assets/config/manifest.js app/assets/config/

# Database configuration
ENV DATABASE_ADAPTER=sqlite3
ENV DATABASE_DATABASE_PRODUCTION=db/production.sqlite3

# Database population
RUN bin/rails db:create db:migrate db:seed

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]