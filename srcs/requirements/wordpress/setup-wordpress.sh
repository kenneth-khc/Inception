#!/usr/bin/env bash

endpoint="$WORDPRESS_DB_HOST:$WORDPRESS_DB_PORT"
attempt=0
max_attempts=10
until (echo >"/dev/tcp/$WORDPRESS_DB_HOST/$WORDPRESS_DB_PORT") >/dev/null 2>&1; do
   attempt=$((attempt + 1))
   echo "Waiting for $endpoint... (attempt $attempt/$max_attempts)"

   if [[ $attempt -ge $max_attempts ]]; then
     echo "Could not resolve $endpoint after $max_attempts attempts. Exiting."
     exit 1
   fi

   sleep 1
done

echo "$endpoint is ready for connections.";
# TODO: the previous section only checks that the mariadb socket is ready
# and listening. gotta make sure that the user is actually set up
# and ready for us to connect. hack it with a sleep for now
sleep 3;

WORDPRESS_DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")
if [ ! -f "$WORDPRESS_PATH/wp-config.php" ]; then
   echo "Creating wp-config.php..."
   wp config create \
      --dbhost="$endpoint" \
      --dbname="$WORDPRESS_DB_NAME" \
      --dbuser="$WORDPRESS_DB_USER" \
      --dbpass="$WORDPRESS_DB_PASSWORD"
else
   echo "wp-config.php is already set up. Proceeding..."
fi

if wp core is-installed; then
   echo "Wordpress is already installed. Proceeding..."
else
   WORDPRESS_ADMIN_PASSWORD=$(cat "$WORDPRESS_ADMIN_PASSWORD_FILE")
   echo "Wordpress is not yet installed."
   echo "Installing Wordpress..."
   # TODO: map kecheong.42.fr to localhost
   wp core install \
      --url="localhost" \
      --title="Inception!!!" \
      --admin_user="$WORDPRESS_ADMIN_NAME" \
      --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
      --admin_email="$WORDPRESS_ADMIN_EMAIL" \
      --skip-email \
      --locale="en_US"
   WORDPRESS_USER_PASSWORD=$(cat "$WORDPRESS_USER_PASSWORD_FILE")
   wp user create "$WORDPRESS_USER_NAME" "$WORDPRESS_USER_EMAIL" \
      --user_pass="$WORDPRESS_USER_PASSWORD" \
      --role=contributor
fi

favicon="$WORDPRESS_PATH/wp-includes/images/favicon.ico"
if [[ ! -f "$favicon" && -f /tmp/cat-favicon.png ]]; then
   mv /tmp/cat-favicon.png "$favicon"
fi

exec php-fpm8.4 --nodaemonize
