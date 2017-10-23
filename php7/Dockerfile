FROM php:7-fpm-alpine

RUN apk update \
  && apk add --virtual .ext-deps make autoconf g++ gcc libc-dev curl ca-certificates bash openssl-dev git re2c file graphviz imagemagick-dev libxslt-dev libtool icu-dev

RUN pear update-channels 

RUN docker-php-ext-install mysqli pdo_mysql

RUN pecl install redis \
    && docker-php-ext-enable redis

RUN apk add --no-cache --virtual .mongodb-ext-build-deps pcre-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

RUN yes | pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-install xsl

RUN apk add linux-headers \
    && pecl install swoole \
    && docker-php-ext-enable swoole

RUN docker-php-ext-install zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

COPY php.conf /tmp/php.conf
RUN cat /tmp/php.conf >> /usr/local/etc/php/php.ini

RUN mkdir -p /tmp/h5/compiled/ \
    && chmod -R 777 /tmp/h5/

RUN echo 'xdebug.remote_autostart = 1' >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo 'xdebug.remote_enable = 1' >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo 'xdebug.remote_port = 9009' >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo 'xdebug.remote_host = docker.for.mac.localhost' >> /usr/local/etc/php/conf.d/xdebug.ini
# && echo 'xdebug.remote_connect_back = 1' >> /usr/local/etc/php/conf.d/xdebug.ini

# blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire.so -D - -L -s https://packages.blackfire.io/binaries/blackfire-php/1.17.3/blackfire-php-alpine_amd64-php-${version}.so \
    && mv /tmp/blackfire.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini


WORKDIR /tmp
