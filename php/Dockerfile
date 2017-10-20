FROM php:5.6-fpm-alpine

WORKDIR /tmp

RUN apk update \
  && apk --update add make autoconf g++ gcc libc-dev curl ca-certificates bash openssl-dev git re2c file graphviz imagemagick-dev libxslt-dev libtool icu-dev pcre-dev

RUN docker-php-ext-install mysql mysqli pdo_mysql

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

RUN pecl install -o -f mongo \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable mongo

RUN yes | pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-install xsl

RUN pecl install imagick \
    && docker-php-ext-enable imagick

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN git clone https://github.com/phalcon/cphalcon --depth 1 \
  && cd cphalcon/build/ \
  && git checkout -b '1.3.1' \
  && ./install \
  && echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini

COPY php.conf /tmp/php.conf
RUN cat /tmp/php.conf > /usr/local/etc/php/php.ini


RUN echo 'xdebug.remote_autostart = 1' >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo 'xdebug.remote_enable = 1' >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo 'xdebug.remote_port = 9009' >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo 'xdebug.remote_host = docker.for.mac.localhost' >> /usr/local/etc/php/conf.d/xdebug.ini
# && echo 'xdebug.remote_connect_back = 1' >> /usr/local/etc/php/conf.d/xdebug.ini

RUN mkdir -p /tmp/h5/compiled/ \
    && chmod -R 777 /tmp/h5/
