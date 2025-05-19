FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    mkdir -p /etc/nginx/ssl /var/www/wordpress && \
    rm -rf /var/lib/apt/lists/*

# Générer certificat SSL auto-signé
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=login.42.fr"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
