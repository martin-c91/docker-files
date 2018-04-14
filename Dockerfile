FROM php:7.2.0-apache
MAINTAINER Martin Chea<martinchea@gmail.com>

# virtualhost
#backup original .conf enabled file
RUN mv /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf.backup
COPY mysite.conf /etc/apache2/sites-enabled/000-default.conf
COPY php.ini /usr/local/etc/php
RUN a2enmod rewrite

# update and install essential
RUN apt-get update
RUN apt-get install -y nano

# xdebug
RUN pecl install -o -f xdebug && rm -rf /tmp/pear

# install composer
WORKDIR /tmp

RUN apt-get update && apt-get install -y zlib1g-dev \
    && docker-php-ext-install zip
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#ENV XDEBUGINI_PATH=/usr/local/etc/php/conf.d/xdebug.ini
#RUN echo "zend_extension="`find /usr/local/lib/php/extensions/ -iname 'xdebug.so'` > $XDEBUGINI_PATH
#COPY xdebug.ini /tmp/xdebug.ini
#RUN cat /tmp/xdebug.ini >> $XDEBUGINI_PATH
#RUN echo "xdebug.remote_host="'/sbin/ip route|awk '/default/ { print $3 }' >> $XDEBUGINI_PATH

#RUN service apache2 restart

# Expose apache.
EXPOSE 80