# Use the official PHP 8.2 image
FROM php:8.2-apache

# Install necessary PHP extensions
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev pkg-config libssl-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy application files
COPY . /var/www/html/

# Copy vendor directory
COPY vendor /var/www/html/vendor

# Set working directory
WORKDIR /var/www/html

# Set permissions for assets directory
RUN mkdir -p /var/www/html/assets && chown -R www-data:www-data /var/www/html/assets && chmod -R 775 /var/www/html/assets

# Set ServerName to avoid warnings
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
