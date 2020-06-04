FROM ruby:2.6.3-alpine

# yarn repository
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - >/dev/null && \
#     echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apk --update-cache upgrade && apk add \
  build-base \
  nodejs \ 
  yarn \
  postgresql-dev \
  tmux \
  curl \
  tzdata

# https://github.com/gliderlabs/docker-alpine/issues/144
# Install language pack
# RUN apk --no-cache add ca-certificates wget && \
#     wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
#     wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
#     wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-bin-2.25-r0.apk && \
#     wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk && \
#     apk add glibc-bin-2.25-r0.apk glibc-i18n-2.25-r0.apk glibc-2.25-r0.apk
# Iterate through all locale and install it
# Note that locale -a is not available in alpine linux, use `/usr/glibc-compat/bin/locale -a` instead
# COPY ./locale.md /locale.md
# RUN cat locale.md | xargs -i /usr/glibc-compat/bin/localedef -i {} -f UTF-8 {}.UTF-8

# Set the lang, you can also specify it as as environment variable through docker-compose.yml
ENV LANG=es_ES.UTF-8 \
    LANGUAGE=es_ES.UTF-8

# Locales
# # Ojo ver esto: https://algodelinux.com/configurar-locales-y-eliminar-el-aviso/
# RUN locale-gen es_ES.UTF-8
# ENV LANG es_ES.UTF-8
# ENV LANGUAGE es_ES:en
# ENV LC_ALL es_ES.UTF-8

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
COPY ./docker/docker_entrypoint.sh /bin
ENTRYPOINT ["/bin/docker_entrypoint.sh"]


