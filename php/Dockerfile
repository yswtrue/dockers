FROM php:5.6-fpm-alpine

RUN apk --update add git make autoconf g++ gcc libc-dev curl ca-certificates bash re2c
##Phalcon##

WORKDIR /tmp

RUN git clone https://github.com/phalcon/cphalcon --depth 1 \
  && cd cphalcon/build/ \
  && git checkout -b '1.3.1' \
  && ./install \
  && rm -rf /tmp/* \
  && echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini
