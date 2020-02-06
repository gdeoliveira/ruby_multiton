FROM alpine:latest
LABEL maintainer "Gabriel de Oliveira <deoliveira.gab@gmail.com>"

WORKDIR /opt/app/
COPY . .

RUN set -euvxo pipefail\
 && apk upgrade --available --latest --no-cache\
 && apk add --no-cache\
  git\
  libffi-dev\
  openssh-client\
  ruby-irb\
 && apk add --no-cache --virtual .build_dependencies\
  g++\
  libffi-dev\
  make\
  ruby-dev\
  zlib-dev\
 && gem update --clear-sources --no-document --system\
 && gem update --clear-sources --no-document\
 && gem cleanup\
 && mkdir ../container/\
 && mkdir ../container/coverage/\
 && mkdir ../container/doc/\
 && mkdir ../container/pkg/\
 && mkdir ../container/tmp/\
 && bundle install\
 && bundle clean --force\
 && apk del --no-cache .build_dependencies

CMD ["/bin/ash"]
