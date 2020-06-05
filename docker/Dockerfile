FROM ruby:2.6.3-alpine

ARG USER_ID
ARG GROUP_ID

RUN apk --update-cache upgrade && apk add \
  build-base \
  nodejs \ 
  yarn \
  postgresql-dev \
  tmux \
  curl \
  tzdata \
  sudo

ENV USERNAME=rails
ENV GROUPNAME=rails

# Add user with host user id and give permissions to required directories
# bundle requires to execute cp and mkdir commands with sudo, 
# so it makes no sense to restrict to some commands: we are screwed anyway
RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    adduser -u ${USER_ID} -D ${USERNAME} && \
    adduser ${USERNAME} adm && \        
    echo cd /app >> /etc/profile && \
    echo "alias ll='ls -la'" >> /etc/profile && \
    chgrp rails /usr/local/bin -R && \
    chmod g+w /usr/local/bin -R && \
    echo '%adm ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
;fi

# Do I really need language packs?
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

RUN mkdir -p /app
WORKDIR /app

# rvm installation
# this was to avoid "bundle exec" everything, but it is not implemented
# RUN apt-get install -y software-properties-common && \
#     apt-add-repository -y ppa:rael-gc/rvm && \
#     apt-get update && \
#     apt-get install -y rvm

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
RUN gem install bundler

RUN mkdir -p /app/node_modules && \
    chgrp rails /app/node_modules -R && \
    chmod g+sw /app/node_modules -R
VOLUME ["/app/node_modules"]

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
RUN chmod ugo+x /bin/docker_entrypoint.sh
ENTRYPOINT ["/bin/docker_entrypoint.sh"]


