# Start with a base image containing PHP 7.2 and Apache
FROM php:7.2-apache

# Set work directory
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY ./app /var/www/html

# Define volumes for persistent data
VOLUME /var/www/html/

# Make directories writable and change ownership
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 777 /var/www/html

# Install necessary packages
RUN apt-get update && apt-get install -y wget unzip

# Install curl
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download and install ionCube Loader
RUN wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvzf ioncube_loaders_lin_x86-64.tar.gz \
    && rm ioncube_loaders_lin_x86-64.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.2.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/ \
    && echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20170718/ioncube_loader_lin_7.2.so" >> /usr/local/etc/php/php.ini \
    && rm -Rf ioncube

# Enable url_fopen in php.ini
RUN echo 'allow_url_fopen = On' >> /usr/local/etc/php/php.ini

# Enable mod_rewrite
RUN a2enmod rewrite

# Install MySQL extension for PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Make port 80 available to the world outside this container
EXPOSE 80
EXPOSE 443

# Run app.py when the container launches
CMD ["apache2-foreground"]
