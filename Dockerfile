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
ENV OVERMIND_SOCKET=./.overmind_docker.sock
RUN wget https://github.com/DarthSim/overmind/releases/download/v2.1.1/overmind-v2.1.1-linux-amd64.gz -O /tmp/overmind.gz && \
    gunzip /tmp/overmind.gz && \
    mv /tmp/overmind /bin && \
    chmod ugo+x /bin/overmind

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# rvm installation
# this was to avoid "bundle exec" everything, but it is not implemented
# RUN apt-get install -y software-properties-common && \
#     apt-add-repository -y ppa:rael-gc/rvm && \
#     apt-get update && \
#     apt-get install -y rvm

RUN gem install bundler


# Configure an entry point, so we don't need to specify
# "bundle exec" for each of our commands.
#
# For example, you can run tests with:
# docker-compose run --rm app "rake test"
#
# You can override it using --entrypoint="", for example:
# docker-compose run --rm --entrypoint "" app "ls -la"
#
# entrypoint.sh will run overmind by default do no CMD is needed
COPY docker_entrypoint.sh /bin
ENTRYPOINT ["/bin/docker_entrypoint.sh"]


