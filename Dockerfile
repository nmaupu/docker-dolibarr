FROM php:5.6-apache
MAINTAINER Benoit Podwinski

ARG VERSION
ENV PHP_TIMEZONE UTC
ENV PHP_MEMORY_LIMIT 128M
ENV MAX_UPLOAD 64M

RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libldap2-dev libpq-dev cron wget curl \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pgsql \
    && apt-get purge -y libpng12-dev libjpeg-dev libldap2-dev

COPY php.ini /usr/local/etc/php/
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

RUN cd /tmp \
    && curl "https://codeload.github.com/Dolibarr/dolibarr/tar.gz/${VERSION}" -o dolibarr.tar.gz \
    && tar -xzf dolibarr.tar.gz \
    && cp -R dolibarr-$VERSION/htdocs/. /var/www/html \
    && rm -R dolibarr-$VERSION \
    && rm dolibarr.tar.gz \
    && chown -R www-data:www-data /var/www/html

COPY pdf_mycrabe.modules.php /var/www/html/core/modules/facture/doc/pdf_mycrabe.modules.php

WORKDIR ["/var/www/html"]
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

EXPOSE 80
