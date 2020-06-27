# https://github.com/phusion/passenger-docker
# This image ships with ruby-2.6.6
FROM phusion/passenger-ruby26:1.0.10


# Temporal for debuggin
# RUN apt update && apt install iputils
COPY ./tmp/ping /usr/bin
COPY ./tmp/traceroute.db /usr/bin/traceroute

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

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

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enable nginx
RUN rm -f /etc/service/nginx/down

# Configure nginx
RUN rm /etc/nginx/sites-enabled/default
ADD ./docker/webapp.conf /etc/nginx/sites-enabled/webapp.conf

# Copy app
RUN mkdir /home/app/webapp && chown app:app /home/app/webapp
COPY --chown=app:app . /home/app/webapp


# With app user:
# gem install bundler:2.1.4
# bundle install