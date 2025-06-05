# Stable version
FROM debian:bullseye

# Update system and install PHP + dependencies
RUN apt update -y && apt upgrade -y
RUN apt-get install -y php7.4 php7.4-fpm php7.4-mysql wget mariadb-client sed

# Create necessary directories for PHP-FPM
RUN mkdir -p /run/php
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Download and install WordPress
RUN wget https://wordpress.org/latest.tar.gz && tar -xzf latest.tar.gz && \
    mv wordpress/* /var/www/html && rm -rf wordpress latest.tar.gz

# Configure PHP-FPM to listen on network instead of Unix socket (socket = btw apps VS TCP = btw containers or machines)
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Set PHP-FPM user and group to www-data (default user for web servers ~= root)
RUN sed -i 's|^;listen.owner = .*|listen.owner = www-data|' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's|^;listen.group = .*|listen.group = www-data|' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's|^;listen.mode = .*|listen.mode = 0660|' /etc/php/7.4/fpm/pool.d/www.conf

# Configure PID file for PHP-FPM (PID file is used to manage the PHP-FPM process = know if it's running)
RUN sed -i 's|^;pid = .*|pid = /run/php/php7.4-fpm.pid|' /etc/php/7.4/fpm/php-fpm.conf

# Copy my setupWP script on the filesystem
COPY tools/setupWP.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setupWP.sh

# Install WP-CLI for WordPress management
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Expose PHP-FPM port
EXPOSE 9000

# Run setupWP script then start PHP-FPM
CMD ["/bin/bash", "-c", "/usr/local/bin/setupWP.sh && /usr/sbin/php-fpm7.4 -F"]