
FROM php:8.2-apache


RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev pkg-config libssl-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb


RUN a2enmod rewrite

COPY . /var/www/html/

COPY vendor /var/www/html/vendor

WORKDIR /var/www/html


RUN mkdir -p /var/www/html/assets && chown -R www-data:www-data /var/www/html/assets && chmod -R 775 /var/www/html/assets


RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
