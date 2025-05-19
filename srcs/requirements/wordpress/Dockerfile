FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y \
        php \
        php-fpm \
        php-mysql \
        mariadb-client \
        wget \
        curl \
        unzip \
        less \
        vim \
        gnupg \
        lsb-release && \
    apt-get clean

	RUN wget https://fr.wordpress.org/wordpress-6.4.2-fr_FR.tar.gz -P /tmp && \
    tar -xzf /tmp/wordpress-6.4.2-fr_FR.tar.gz -C /tmp && \
    mv /tmp/wordpress-6.4.2-fr_FR /tmp/wordpress && \
    rm -rf /tmp/wordpress-6.4.2-fr_FR.tar.gz

# Entrypoint qui déplace WordPress si le volume est vide
COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "php-fpm7.4", "-F" ]