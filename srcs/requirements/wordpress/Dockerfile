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

COPY tools/setupWP.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setupWP.sh && \
    dos2unix /usr/local/bin/setupWP.sh

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

CMD ["/usr/local/bin/setupWP.sh"]
