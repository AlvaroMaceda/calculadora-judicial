FROM ruby:2.6.3

# yarn repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - >/dev/null && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  build-essential \
  nodejs \ 
  yarn \
  libpq-dev \
  locales \
  tmux

# Locales
# Ojo ver esto: https://algodelinux.com/configurar-locales-y-eliminar-el-aviso/
RUN locale-gen es_ES.UTF-8
ENV LANG es_ES.UTF-8
ENV LANGUAGE es_ES:en
ENV LC_ALL es_ES.UTF-8

# Overmind installation
RUN wget https://github.com/DarthSim/overmind/releases/download/v2.1.1/overmind-v2.1.1-linux-amd64.gz -O /tmp/overmind.gz && \
    gunzip /tmp/overmind.gz && \
    mv /tmp/overmind /bin && \
    chmod ugo+x /bin/overmind

# ENV PATH "$PATH:$INSTALL_PATH/bin"

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# # Install rbenv so we don't have to bundle exec everything
# ENV PATH="$HOME/.rbenv/bin:$PATH"
# RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash

# rvm installation
# RUN apt-get install -y software-properties-common && \
#     apt-add-repository -y ppa:rael-gc/rvm && \
#     apt-get update && \
#     apt-get install -y rvm

# Gems installation
# Hacer esto en producción, aquí no
# COPY Gemfile Gemfile.lock ./
RUN gem install bundler
# RUN bundle check || bundle install --jobs 20 --retry 5


# Packages installation
# Hacer esto en producción, aquí no
# COPY package.json yarn.lock ./
# RUN yarn install --check-files

# COPY . ./
# COPY . /app

# # Application data
# RUN mkdir /data
# COPY ./data /data

# Configure an entry point, so we don't need to specify
# "bundle exec" for each of our commands.
# For example, you can run tests with:
# docker-compose run --rm app "rake test"
# You can override it using --entrypoint="", for example:
# docker-compose run --rm --entrypoint "" app "ls -la"
ENTRYPOINT ["bundle", "exec"]

# Start the rails server by default
# CMD ["rails", "server", "-b", "0.0.0.0"]

# Start overmind