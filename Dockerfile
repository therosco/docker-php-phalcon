FROM php:7.3-fpm-stretch

ADD ./tools/*.sh /tmp/

RUN apt-get update && \
    apt-get install -y apt-utils git procps ngrep wget zip unzip zlib1g-dev inetutils-ping mysql-client curl  \
        libfreetype6-dev libjpeg62-turbo-dev libpng-dev libc-client-dev libkrb5-dev libzip-dev && \
    docker-php-source extract && \
    pecl install psr apcu && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install -j$(nproc) zip mysqli pdo_mysql gd imap && \
    docker-php-ext-enable apcu psr && \
    cd /root && \
    git clone --depth=1 --single-branch --branch 3.4.x "git://github.com/phalcon/cphalcon.git" && \
    cd cphalcon/build && \
    ./install && \
    echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini && \
    docker-php-source delete && \
    /tmp/composer-install.sh