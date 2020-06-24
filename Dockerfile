# From https://medium.com/@lemuelbarango/ruby-on-rails-smaller-docker-images-bff240931332
FROM ruby:2.6.3-alpine AS builder

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
RUN bin/rails assets:precompile

# Remove folders not needed in resulting image
RUN rm -rf node_modules tmp/cache app/assets vendor/assets spec tmp /db/*.sqlite3

############### Build step done ###############
FROM ruby:2.6.3-alpine
# Uncomment this if you want to 
# FROM build-container as deploy


# --------------------------------------------------------------------------------------------
# nginx
# --------------------------------------------------------------------------------------------
ENV NGINX_VERSION 1.19.0
ENV NJS_VERSION   0.4.1
ENV PKG_RELEASE   1

RUN \
# create nginx user/group first, to be consistent throughout docker variants
    addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && nginxPackages=" \
        nginx=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-xslt=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-geoip=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-image-filter=${NGINX_VERSION}-r${PKG_RELEASE} \
        nginx-module-njs=${NGINX_VERSION}.${NJS_VERSION}-r${PKG_RELEASE} \
    " \
# arches officially built by upstream    
    # && set -x \
    && KEY_SHA512="e7fa8303923d9b95db37a77ad46c68fd4755ff935d0a534d26eba83de193c76166c68bfe7f65471bf8881004ef4aa6df3e34689c305662750c0172fca5d8552a *stdin" \
    && apk add --no-cache --virtual .cert-deps \
        openssl \
    && wget -O /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
    && if [ "$(openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout | openssl sha512 -r)" = "$KEY_SHA512" ]; then \
        echo "key verification succeeded!"; \
        mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/; \
    else \
        echo "key verification failed!"; \
        exit 1; \
    fi \
    && apk del .cert-deps \
    && apk add -X "https://nginx.org/packages/mainline/alpine/v$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" --no-cache $nginxPackages \
# if we have leftovers from building, let's purge them (including extra, unnecessary build deps)
    && if [ -n "$tempDir" ]; then rm -rf "$tempDir"; fi \
    && if [ -n "/etc/apk/keys/abuild-key.rsa.pub" ]; then rm -f /etc/apk/keys/abuild-key.rsa.pub; fi \
    && if [ -n "/etc/apk/keys/nginx_signing.rsa.pub" ]; then rm -f /etc/apk/keys/nginx_signing.rsa.pub; fi \
# Bring in tzdata so users could set the timezones through the environment
# variables
    && apk add --no-cache tzdata \
# Bring in curl and ca-certificates to make registering on DNS SD easier
    && apk add --no-cache curl ca-certificates \
# forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Nginx configuration
# COPY docker/nginx.prod.conf docker/production/nginx/default.conf

# --------------------------------------------------------------------------------------------
# Ruby
# --------------------------------------------------------------------------------------------
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

# ***Copy only necessary files
COPY --from=builder $RAILS_ROOT $RAILS_ROOT
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

# Required by sprockets
COPY /app/assets/config/manifest.js app/assets/config/

# Database configuration
ENV DATABASE_ADAPTER=sqlite3
ENV DATABASE_DATABASE_PRODUCTION=db/production.sqlite3

# Database population
RUN bundle exec rails db:create db:migrate db:seed

EXPOSE 3000

# CMD ["bin/rails", "server", "-b", "0.0.0.0"]
# CMD [ "sh", "-c", "bundle exec rake db:create db:migrate && bundle exec rails server -b 0.0.0.0" ]
CMD [ "sh", "-c", "bundle exec rails server -b 0.0.0.0" ]