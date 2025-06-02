#!/bin/sh

# Lire le mot de passe root depuis le fichier secret
PASSWORD=$(cat /run/secrets/db_root_password.txt)

# Ping la base de données avec mysqladmin
mysqladmin ping -h localhost -u root -p"$PASSWORD"