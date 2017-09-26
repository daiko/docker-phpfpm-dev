FROM php:7-fpm

RUN curl -o /tmp/xdebug.tgz https://xdebug.org/files/xdebug-2.5.5.tgz && \
    mkdir -p /usr/src/php/ext/xdebug && \
    tar xzf /tmp/xdebug.tgz -C /usr/src/php/ext/xdebug/ && \
    rm /tmp/xdebug.tgz && \
    mv /usr/src/php/ext/xdebug/xdebug*/* /usr/src/php/ext/xdebug/

RUN apt-get update && apt-get install -y \
	    ssmtp \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        mariadb-client \
    && docker-php-ext-install -j$(nproc) iconv mcrypt gd zip sockets \
    && docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql \
    && docker-php-ext-install -j$(nproc) xdebug\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN setcap cap_net_raw=eip /usr/local/bin/php 
