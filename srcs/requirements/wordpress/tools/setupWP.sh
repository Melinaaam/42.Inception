#!/bin/sh
set -e # Exit on any error

WP_PATH="/var/www/html"

# Create PHP-FPM runtime directory
mkdir -p /run/php

# Download WordPress if not present
if [ ! -f "$WP_PATH/wp-load.php" ]; then
  echo "Téléchargement de WordPress..."
  wp core download --path="$WP_PATH" --allow-root
fi

# Create wp-config.php with database connection
cat <<EOF > "$WP_PATH/wp-config.php"
<?php
define('DB_NAME', '${MYSQL_DATABASE}');
define('DB_USER', '${MYSQL_USER}');
define('DB_PASSWORD', '${MYSQL_PASSWORD}');
define('DB_HOST', '${WP_DB_HOST}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
\$table_prefix = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') ) define('ABSPATH', __DIR__ . '/');
require_once ABSPATH . 'wp-settings.php';
EOF

# Wait for MariaDB to be ready
echo "Attente de MariaDB..."
until mysql -h "${WP_DB_HOST}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1" > /dev/null 2>&1; do
  echo "Attente de MariaDB... ($(date))"
  sleep 5
done

echo "MariaDB est prêt!"

# Set proper permissions
chown -R www-data:www-data "$WP_PATH"
chmod -R 755 "$WP_PATH"

# Install WordPress if not already done
if ! wp core is-installed --path="$WP_PATH" --allow-root; then
  echo "Installation de WordPress..."
  wp core install \
    --path="$WP_PATH" \
    --url="https://${DOMAIN_NAME}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --allow-root
  
  echo "Création de l'utilisateur..."
  wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
    --user_pass="${WP_USER_PASSWORD}" \
    --role=editor \
    --path="$WP_PATH" \
    --allow-root
fi

echo "Démarrage de PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F # Run in foreground