# Use an official PHP runtime as a parent image
FROM php:7.2-apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Fix permissions and ownership
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Install IonCube Loader for PHP 7.2
RUN curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.2.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/ioncube_loader_lin_7.2.so \
    && echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20170718/ioncube_loader_lin_7.2.so" > /usr/local/etc/php/conf.d/00-ioncube.ini \
    && rm -rf ioncube.tar.gz ioncube

# Enable allow_url_fopen
RUN echo "allow_url_fopen = On" > /usr/local/etc/php/conf.d/01-allow_url_fopen.ini

# Install cURL
RUN apt-get update && apt-get install -y libcurl4-openssl-dev \
    && docker-php-ext-install curl

# Install MySQL extension for PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Enable mod_rewrite and SSL
RUN a2enmod rewrite \
    && a2enmod ssl

# Generate a self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Configure Apache to use the SSL certificate
COPY apache-config/ssl.conf /etc/apache2/sites-available/default-ssl.conf
RUN a2ensite default-ssl

# Expose port 443 for HTTPS
EXPOSE 443
EXPOSE 80

# Define the command to run your application
CMD ["apache2-foreground"]
