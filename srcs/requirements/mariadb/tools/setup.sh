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
    sleep 10
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

# #!/bin/bash

# # Set non-interactive mode
# export DEBIAN_FRONTEND=noninteractive

# # Start MariaDB service
# service mariadb start
# sleep 10

# DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password.txt)
# DB_PASSWORD=$(cat /run/secrets/db_password.txt)


# # Check if database already exists (avoid recreation)
# DB_EXISTS=$(mysql -u root -p"${DB_ROOT_PASSWORD}" -e "SHOW DATABASES LIKE '${MYSQL_DATABASE}'" 2>/dev/null | wc -l)

# if [ "$DB_EXISTS" -eq 0 ]; then
#     echo "Création de la base de données et des utilisateurs..."
    
#     # Create database
#     mysql -u root -p"${DB_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    
#     # Create user with % wildcard for network access
#     mysql -u root -p"${DB_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';"
    
#     # Grant privileges
#     mysql -u root -p"${DB_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    
#     # Update root password
#     mysql -u root -p"${DB_ROOT_PASSWORD}" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
    
#     # Apply changes
#     mysql -u root -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
    
#     echo "Configuration terminée."
# else
#     echo "Base de données déjà configurée."
# fi

# # Graceful shutdown and restart with mysqld_safe
# mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown

# # Keeps container running but with mysqld_safe who will handle the process management & restart f crashes
# exec mysqld_safe