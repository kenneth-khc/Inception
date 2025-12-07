#!/usr/bin/env bash

attempt=0
max_attempts=10
until (echo >/dev/tcp/mariadb/3306) >/dev/null 2>&1; do
   attempt=$((attempt + 1))
   echo "Waiting for mariadb:3306... (attempt $attempt/$max_attempts)"

   if [[ $attempt -ge $max_attempts ]]; then
     echo "Could not resolve mariadb:3306 after $max_attempts attempts. Exiting."
     exit 1
   fi

   sleep 1
done

echo "MariaDB is ready";
# TODO: the previous section only checks that the mariadb socket is ready
# and listening. gotta make sure that the user is actually set up
# and ready for us to connect. hack it with a sleep for now
sleep 3;

# TODO: read from env
if [ ! -f /srv/wordpress/wp-config.php ]; then
   echo "Creating wp-config.php..."
   DB_PASSWORD=mysupersecretuserpassword
   wp config create \
      --dbhost=mariadb:3306 \
      --dbname=wordpress_db \
      --dbuser=wordpress_user --dbpass="$DB_PASSWORD"
else
   echo "wp-config.php is already set up. Proceeding..."
fi

if wp core is-installed; then
   echo "Wordpress is already installed. Proceeding..."
else
   echo "Wordpress is not yet installed."
   echo "Installing Wordpress..."
   # TODO: map kecheong.42.fr to localhost
   wp core install \
      --url="localhost" \
      --title="Inception!!!" \
      --admin_user="kecheong4242" \
      --admin_password="password4242" \
      --admin_email="kecheong4242@email.com" \
      --skip-email \
      --locale="en_US"
fi

exec php-fpm8.4 --nodaemonize
