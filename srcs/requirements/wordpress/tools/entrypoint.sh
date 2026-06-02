#!/bin/bash
set -e

WP_PATH=/var/www/wordpress
mkdir -p ${WP_PATH}

# Wait for MariaDB
echo "Waiting for MariaDB..."
for i in {60..0}; do
    if mysql -h mariadb -u "${DB_USER}" -p"$(cat /run/secrets/db_password)" "${DB_NAME}" -e "SELECT 1" &>/dev/null; then
        break
    fi
    sleep 2
done

if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    echo "Downloading WordPress..."
    wp core download --path="${WP_PATH}" --allow-root

    echo "Creating wp-config.php..."
    wp config create --path="${WP_PATH}" \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="$(cat /run/secrets/db_password)" \
        --dbhost=mariadb \
        --allow-root

    echo "Installing WordPress..."
    wp core install --path="${WP_PATH}" \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="$(cat /run/secrets/wp_admin_password)" \
        --admin_email="${WP_ADMIN_USER}@${DOMAIN_NAME}" \
        --allow-root

    wp user create --path="${WP_PATH}" \
        "${WP_USER}" "${WP_USER}@${DOMAIN_NAME}" \
        --role=author \
        --allow-root

    echo "WordPress setup complete."
fi

mkdir -p /run/php

exec "$@"
