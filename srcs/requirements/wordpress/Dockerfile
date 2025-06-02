FROM debian:bullseye

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y \
        php7.4-fpm \
        php7.4-mysql \
        php-curl \
        php-gd \
        php-mbstring \
        php-xml \
        php-zip \
        mariadb-client \
        wget \
        curl \
        unzip \
        sed \
        less \
        vim \
        gnupg \
        sendmail \
        dos2unix \
        lsb-release && \
    apt clean

RUN mkdir -p /var/www/html /run/php
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Télécharger et installer WordPress
RUN wget https://wordpress.org/latest.tar.gz && tar -xzf latest.tar.gz && \
    mv wordpress/* /var/www/html && rm -rf wordpress latest.tar.gz


RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Set PHP-FPM user and group to www-data (default user for web servers ~= root)
RUN sed -i 's|^;listen.owner = .*|listen.owner = www-data|' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's|^;listen.group = .*|listen.group = www-data|' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's|^;listen.mode = .*|listen.mode = 0660|' /etc/php/7.4/fpm/pool.d/www.conf

# Configure PID file for PHP-FPM (PID file is used to manage the PHP-FPM process = know if it's running)
RUN sed -i 's|^;pid = .*|pid = /run/php/php7.4-fpm.pid|' /etc/php/7.4/fpm/php-fpm.conf


COPY tools/setupWP.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setupWP.sh && \
    dos2unix /usr/local/bin/setupWP.sh

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

CMD ["/bin/bash", "-c", "/usr/local/bin/setupWP.sh && /usr/sbin/php-fpm7.4 -F"]
