#!/bin/bash
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

if [ ! -f "/var/lib/mysql/.init_done" ]; then
    mysqld --user=mysql --skip-networking &
    pid="$!"

    mysqladmin ping --silent --wait=30 &>/dev/null || true

    DB_NAME=${DB_NAME}
    DB_USER=${DB_USER}
    DB_PASS=$(cat /run/secrets/db_password)
    DB_ROOT_PASS=$(cat /run/secrets/db_root_password)

    mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -u root -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
    mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${DB_ROOT_PASS}');"
    mysql -u root -e "FLUSH PRIVILEGES;"

    touch /var/lib/mysql/.init_done

    kill -s TERM "$pid"
    wait "$pid"
fi

exec "$@"
