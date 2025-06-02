FROM debian:bullseye

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

# RUN openssl req -x509 -nodes -days 365 \
RUN openssl req -x509 -nodes \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=memotyle.42.fr/UID=memotyle"

# COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/nginx.conf

RUN mkdir -p /var/run/nginx /var/log/nginx
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]