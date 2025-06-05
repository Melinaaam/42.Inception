FROM debian:bullseye

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y nginx openssl 

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes \
  -out /etc/nginx/ssl/inception.crt \
  -keyout /etc/nginx/ssl/inception.key \
  -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=memotyle.42.fr/UID=memotyle"

# Create nginx runtime directory
RUN mkdir -p /var/run/nginx

# Copy my configuration files in the container filesystem
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Set permissions for web directory
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Run Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]