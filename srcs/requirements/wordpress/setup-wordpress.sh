#!/usr/bin/env bash

attempt=0
max_attempts=10
until (echo >/dev/tcp/mariadb/3306) >/dev/null 2>&1
  do
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
   echo "Password: $DB_PASSWORD"
   wp config create \
      --force \
      --dbhost=mariadb:3306 \
      --dbname=wordpress_db \
      --dbuser=wordpress_user --dbpass="$DB_PASSWORD"
   echo "Creating Wordpress database..."
   wp db create
   echo "Installing Wordpress..."
   wp core install \
      --url="localhost" \
      --title="WP TEST" \
      --admin_user="WP_ADMIN" \
      --admin_password="WP_ADMIN_PASSWORD" \
      --admin_email="admin@email.com" \
      --skip-email \
      --locale="en_US"
else
   echo "Wordpress already set up. Proceeding..."
fi

exec php-fpm8.4 --nodaemonize
