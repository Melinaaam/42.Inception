#!/bin/bash
set -e

echo "Initialisation de MariaDB..."

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password.txt)
DB_PASSWORD=$(cat /run/secrets/db_password.txt)

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de la base de données..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe --skip-networking --socket=/run/mysqld/mysqld.sock &
MYSQL_PID=$!

echo "Attente du démarrage de MariaDB..."
while ! mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; do
    sleep 1
done

mysql --socket=/run/mysqld/mysqld.sock -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

mysqladmin --socket=/run/mysqld/mysqld.sock -u root -p"${DB_ROOT_PASSWORD}" shutdown
wait $MYSQL_PID

echo "Configuration terminée. Démarrage de MariaDB..."

exec mysqld_safe --socket=/run/mysqld/mysqld.sock