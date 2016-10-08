FROM alpine:latest
MAINTAINER Gabriel de Oliveira <deoliveira.gab@gmail.com>

RUN set -euvxo pipefail\
 && apk upgrade --available --latest --no-cache\
 && apk add --no-cache\
  g++\
  git\
  libffi-dev\
  make\
  openssh-client\
  ruby-dev\
  ruby-irb\
 && gem update --clear-sources --no-document --system\
 && gem update --clear-sources --no-document\
 && gem install --clear-sources --no-document\
  bundler\
  io-console\
 && gem cleanup

WORKDIR /opt/app

COPY . .
RUN set -euvxo pipefail\
 && mkdir ../container/\
 && mkdir ../container/coverage/\
 && mkdir ../container/doc/\
 && mkdir ../container/pkg/\
 && mkdir ../container/tmp/\
 && bundle install --clean --no-cache --system\
 && bundle clean --force

CMD ["/bin/ash"]
ENTRYPOINT ["docker/entrypoint.sh"]
