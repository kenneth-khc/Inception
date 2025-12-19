#!/usr/bin/env bash

endpoint="$WP_DB_HOST:$WP_DB_PORT"
attempt=0
max_attempts=10
until (echo >"/dev/tcp/$WP_DB_HOST/$WP_DB_PORT") >/dev/null 2>&1; do
   attempt=$((attempt + 1))
   echo "Waiting for $endpoint... (attempt $attempt/$max_attempts)"

   if [[ $attempt -ge $max_attempts ]]; then
     echo "Could not resolve $endpoint after $max_attempts attempts. Exiting."
     exit 1
   fi

   sleep 1
done

echo "$endpoint is ready for connections.";

DB_USER_CREDENTIALS="/run/secrets/db-user-credentials"
DB_USER=$(awk -F= '$1=="DB_USER" {print $2}' $DB_USER_CREDENTIALS)
DB_PASSWORD=$(awk -F= '$1=="DB_PASSWORD" {print $2}' $DB_USER_CREDENTIALS)
if [ ! -f "$WP_PATH/wp-config.php" ]; then
   echo "Creating wp-config.php..."
   wp config create \
      --dbhost="$endpoint" \
      --dbname="$WP_DB_NAME" \
      --dbuser="$DB_USER" \
      --dbpass="$DB_PASSWORD"
else
   echo "wp-config.php is already set up. Proceeding..."
fi

if wp core is-installed; then
   echo "Wordpress is already installed. Proceeding..."
else
   echo "Wordpress is not yet installed."
   echo "Installing Wordpress..."

   ADMIN_CREDENTIALS="/run/secrets/wp-admin-credentials"
   WP_ADMIN_NAME=$(awk -F= '$1=="WP_ADMIN_NAME" {print $2}' $ADMIN_CREDENTIALS)
   WP_ADMIN_PASSWORD=$(awk -F= '$1=="WP_ADMIN_PASSWORD" {print $2}' $ADMIN_CREDENTIALS)
   WP_ADMIN_EMAIL=$(awk -F= '$1=="WP_ADMIN_EMAIL" {print $2}' $ADMIN_CREDENTIALS)
   wp core install \
      --url="kecheong.42.fr" \
      --title="Inception!!!" \
      --admin_user="$WP_ADMIN_NAME" \
      --admin_password="$WP_ADMIN_PASSWORD" \
      --admin_email="$WP_ADMIN_EMAIL" \
      --skip-email \
      --locale="en_US"

   USER_CREDENTIALS="/run/secrets/wp-user-credentials"
   WP_USER_NAME=$(awk -F= '$1=="WP_USER_NAME" {print $2}' $USER_CREDENTIALS)
   WP_USER_PASSWORD=$(awk -F= '$1=="WP_USER_PASSWORD" {print $2}' $USER_CREDENTIALS)
   WP_USER_EMAIL=$(awk -F= '$1=="WP_USER_EMAIL" {print $2}' $USER_CREDENTIALS)
   wp user create "$WP_USER_NAME" "$WP_USER_EMAIL" \
      --user_pass="$WP_USER_PASSWORD" \
      --role=contributor

   # set group sticky bit and write permission on uploads dir to demonstrate ftp
   chmod -R g+sw "$WP_PATH/wp-content/uploads"
fi

favicon="$WP_PATH/wp-includes/images/favicon.ico"
if [[ ! -f "$favicon" && -f /tmp/cat-favicon.png ]]; then
   mv /tmp/cat-favicon.png "$favicon"
fi

if ! wp plugin is-active "redis-cache"; then
   echo "redis-cache is not activated."
   if ! wp plugin is-installed "redis-cache"; then
      echo "redis-cache plugin is not installed."
      echo "Installing redis cache plugin..."
      wp plugin install "redis-cache"
      echo "Successfully installed redis-cache plugin."
   fi
   wp plugin activate "redis-cache"
   echo "Activated redis redis-cache plugin."
   wp config set WP_REDIS_HOST "redis"
   wp config set WP_REDIS_PORT "6379"
   wp redis enable
else
   echo "redis-cache is already activated. Proceeding..."
fi

exec php-fpm8.4 --nodaemonize
