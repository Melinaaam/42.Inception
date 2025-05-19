#!/bin/bash

# Attendre que MariaDB soit prêt
sleep 10

cd /var/www/wordpress

# Si wp-config n'existe pas encore
if [ ! -f wp-config.php ]; then

  wp config create \
    --dbname=$MYSQL_DATABASE \
    --dbuser=$MYSQL_USER \
    --dbpass=$MYSQL_PASSWORD \
    --dbhost=mariadb:3306 \
    --path='/var/www/wordpress' \
    --allow-root

  wp core install \
    --url=https://$DOMAIN_NAME \
    --title="Inception Site" \
    --admin_user=$WP_ADMIN \
    --admin_password=$WP_ADMIN_PASSWORD \
    --admin_email=$WP_ADMIN_EMAIL \
    --skip-email \
    --path='/var/www/wordpress' \
    --allow-root

  wp user create \
    $WP_USER \
    $WP_USER_EMAIL \
    --user_pass=$WP_USER_PASSWORD \
    --role=editor \
    --allow-root
fi

# Lancer PHP-FPM
exec php-fpm7.3 -F
