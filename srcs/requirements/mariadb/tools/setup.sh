#!/bin/bash

service mariadb start;
sleep 10;

export DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password.txt)
export DB_PASSWORD=$(cat /run/secrets/db_password.txt)

# Test if root password is already set
if mysql -u root -p"${DB_ROOT_PASSWORD}" -e "SELECT 1" 2>/dev/null; then
    # Root password already set, use it for all commands
    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '\${MYSQL_USER}'@'localhost' IDENTIFIED BY '\${DB_PASSWORD}';"
    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '\${MYSQL_USER}'@'%' IDENTIFIED BY '\${DB_PASSWORD}';"
    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
else
    # No root password yet, do initial setup without password
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS '\${MYSQL_USER}'@'localhost' IDENTIFIED BY '\${DB_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '\${MYSQL_USER}'@'%' IDENTIFIED BY '\${DB_PASSWORD}';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '\${DB_ROOT_PASSWORD}';"
    mysql -u root -e "FLUSH PRIVILEGES;"
    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
fi

exec mysqld_safe