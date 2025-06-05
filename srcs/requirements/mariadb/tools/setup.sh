#!/bin/bash

# Set non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# Start MariaDB service
service mariadb start
sleep 10

# Check if database already exists (avoid recreation)
DB_EXISTS=$(mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SHOW DATABASES LIKE '${MYSQL_DATABASE}'" 2>/dev/null | wc -l)

if [ "$DB_EXISTS" -eq 0 ]; then
    echo "Création de la base de données et des utilisateurs..."
    
    # Create database
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    
    # Create user with % wildcard for network access
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    
    # Grant privileges
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    
    # Update root password
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    
    # Apply changes
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
    
    echo "Configuration terminée."
else
    echo "Base de données déjà configurée."
fi

# Graceful shutdown and restart with mysqld_safe
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

# Keeps container running but with mysqld_safe who will handle the process management & restart f crashes
exec mysqld_safe