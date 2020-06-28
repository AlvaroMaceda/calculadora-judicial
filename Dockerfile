# https://github.com/phusion/passenger-docker
# This image ships with ruby-2.6.6
FROM phusion/passenger-ruby26:1.0.10

# Set correct environment variables.
ENV HOME /root


# COPY ./tmp/ping /usr/bin/ping
# COPY ./tmp/traceroute.db /usr/bin/traceroute

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features.
#
# N.B. these images are based on https://github.com/phusion/baseimage-docker,
# so anything it provides is also automatically on board in the images below
# (e.g. older versions of Ruby, Node, Python).
#
# Uncomment the features you want:
#
#   Ruby support
#RUN /pd_build/ruby-2.3.*.sh
#RUN /pd_build/ruby-2.4.*.sh
#RUN /pd_build/ruby-2.5.*.sh
# RUN /pd_build/ruby-2.6.*.sh ¿?
#RUN /pd_build/jruby-9.2.*.sh
#   Python support.
#RUN /pd_build/python.sh
#   Node.js and Meteor standalone support.
#   (not needed if you already have the above Ruby support)
#RUN /pd_build/nodejs.sh

# ...put your own build instructions here...

# Configure ruby version
# ENV RUBY_VERSION=ruby-2.6.3
# # RUN bash -lc "rvm --default use $RUBY_VERSION"
# RUN bash -c "rvm install $RUBY_VERSION"
# RUN bash -c "rvm --default use $RUBY_VERSION"

# Install node
RUN apt-get update -y \
    && apt-get install curl gnupg -y \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get install gcc g++ make nodejs -y
# RUN apt-get update -y 
# RUN apt-get install curl gnupg -y
# RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
# RUN apt-get ins

# Install yarn
RUN   curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
   && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
   && apt-get update && apt-get install yarn

# Install tzdata
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime \
 && apt-get update && apt-get install -y tzdata \
 && dpkg-reconfigure --frontend noninteractive tzdata

# Enable nginx
RUN rm -f /etc/service/nginx/down

# Configure nginx
RUN rm /etc/nginx/sites-enabled/default
ADD ./docker/webapp.conf /etc/nginx/sites-enabled/webapp.conf

# Copy app
RUN mkdir /home/app/webapp && chown app:app /home/app/webapp
COPY --chown=app:app . /home/app/webapp

USER app
WORKDIR /home/app/webapp
ENV HOME=/home/app
# RUN whoami

RUN gem install bundler:2.1.4
# RUN bundle install --without development:test:assets -j4 --retry 3 --path=vendor/bundle
RUN bundle install --without test:assets -j4 --retry 3 --path=vendor/bundle
RUN yarn install --check-files
RUN bundle exec rails webpacker:compile


USER root

# FALTAN LAS VARIABLES DE ENTORNO DE RAILS
ENV RAILS_ENV=production
ENV DATABASE_ADAPTER=sqlite3
ENV DATABASE_DATABASE_PRODUCTION=db/production.sqlite3
ENV RAILS_LOG_TO_STDOUT=true
# For debugging
ENV RAILS_ALL_REQUESTS_LOCAL=true 

# Initialize database
RUN bundle exec rails db:create db:migrate db:seed

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]


#----------------------------------------------------------------
# Prod stage
#----------------------------------------------------------------
# FROM phusion/passenger-ruby26:1.0.10