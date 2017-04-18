FROM alpine:latest
LABEL maintainer "Gabriel de Oliveira <deoliveira.gab@gmail.com>"

WORKDIR /opt/app/
COPY . .

RUN set -euvxo pipefail\
 && apk upgrade --available --latest --no-cache\
 && apk add --no-cache\
  git\
  openssh-client\
  ruby-irb\
 && apk add --no-cache --virtual .build_dependencies\
  g++\
  libffi-dev\
  make\
  ruby-dev\
 && gem update --clear-sources --no-document --system\
 && gem update --clear-sources --no-document\
 && gem install --clear-sources --no-document\
  bundler\
  io-console\
 && gem cleanup\
 && mkdir ../container/\
 && mkdir ../container/coverage/\
 && mkdir ../container/doc/\
 && mkdir ../container/pkg/\
 && mkdir ../container/tmp/\
 && bundle install --clean --no-cache --system\
 && bundle clean --force\
 && apk del --no-cache .build_dependencies

CMD ["/bin/ash"]
ENTRYPOINT ["docker/entrypoint.sh"]
