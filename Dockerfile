FROM ruby:2.6.3-alpine
# In ubuntu:
# postgresql-dev == libpq-dev
# build-essential == build-base
# RUN apk update -qq && apk add nodejs yarn postgresql-client postgresql-dev build-base
RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      postgresql-dev \
      python \
      tzdata \
      yarn


ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# Gems installation
COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle check || bundle install --jobs 20 --retry 5

# Packages installation
COPY package.json yarn.lock ./
RUN yarn install --check-files

# COPY . ./
# COPY . /app

# # Application data
# RUN mkdir /data
# COPY ./data /data

# # Add a script to be executed every time the container starts.
# COPY docker_entrypoint.sh /usr/bin/entrypoint.sh
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]
# EXPOSE 3000

# # Start the main process.
# CMD ["rails", "server", "-b", "0.0.0.0"]