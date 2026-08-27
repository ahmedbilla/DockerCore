#!/bin/bash


cd /var/www/html


sleep 10


if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."

    wp core download --allow-root

    echo "Creating wp-config.php..."

    wp config create --allow-root \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASSWORD \
        --dbhost=$DB_HOST

    echo "Installing WordPress..."

    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title="Inception WordPress" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL

    echo "Creating a standard user..."

    wp user create --allow-root \
        $WP_USER \
        $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author

    echo "WordPress is ready!"
else
    echo "WordPress is already installed."
fi


echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 -F