FROM php:8.2-apache


RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev pkg-config libssl-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli \
    && pecl install mongodb redis \
    && docker-php-ext-enable mongodb redis


RUN a2enmod rewrite

WORKDIR /var/www/html

COPY composer.json composer.lock ./
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install

COPY . /var/www/html/


RUN mkdir -p /var/www/html/assets && chown -R www-data:www-data /var/www/html/assets && chmod -R 775 /var/www/html/assets

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
