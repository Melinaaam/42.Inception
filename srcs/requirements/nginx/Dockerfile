FROM debian:bullseye

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

# Générer certificat SSL auto-signé
RUN openssl req -x509 -nodes -days 365 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=memotyle.42.fr/UID=memotyle"

# Copier la configuration
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Créer les répertoires nécessaires
RUN mkdir -p /var/run/nginx /var/log/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]