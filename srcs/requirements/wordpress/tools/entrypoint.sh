#!/bin/bash

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    cp -r /tmp/wordpress/* /var/www/wordpress
fi

exec "$@"
