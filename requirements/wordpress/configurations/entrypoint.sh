#!/bin/bash

# download, make executable, and move wp-cli to bin
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

cd /var/www/wordpress
chmod -R 755 /var/www/wordpress/ # owner can read, write, execute; others only read
chown -R www-data:www-data /var/www/wordpress # change owner to www-data

ping_mariadb() { # function to check mariadb status
    nc -z mariadb 3306 > /dev/null
    return $?
}

timeout=20  # Timeout in seconds
for ((i=0; i<$timeout; i++)); do # wait for mariadb
    if ping_mariadb; then 
        break
    else
        echo "Waiting for MariaDB to start..."
        sleep 1
    fi
done

if ! ping_mariadb; then
    echo "MariaDB is not responding"
    exit 1
fi

wp core download --allow-root # download wordpress

# configure wordpress
wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root
wp user create "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root

sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf # change socket to port 9000

mkdir -p /run/php

/usr/sbin/php-fpm7.4 -F # start php-fpm in foreground
