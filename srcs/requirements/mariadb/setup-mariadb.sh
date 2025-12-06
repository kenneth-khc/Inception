#!/usr/bin/env bash

echo "Setting up MariaDB..."
mariadbd-safe --no-watch

attempt=0
max_attempts=30
mariadb_unix_socket='/run/mysqld/mysqld.sock'
until socat -u OPEN:/dev/null UNIX-CONNECT:"$mariadb_unix_socket" 2>/dev/null
  do
    attempt=$((attempt + 1))
    echo "Waiting for $mariadb_unix_socket... (attempt $attempt/$max_attempts)"

    if [[ $attempt -gt $max_attempts ]]; then
      echo "Could not connect to $mariadb_unix_socket after $max_attempts. Exiting."
      exit 1
    fi

    sleep 1
  done

exitOnError() {
  echo "Something went wrong. Exiting."
  exit 1
}
trap exitOnError ERR

# TODO: read these from env
MARIADB_DATABASE=wordpress_db
MARIADB_USER=wordpress_user
MARIADB_PASSWORD=mysupersecretuserpassword
echo "Creating user $MARIADB_USER..."
mariadb -e "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE;"
mariadb -e "CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD'"
mariadb -e "GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%';"
mariadb -e "FLUSH PRIVILEGES;"
echo "Done creating user $MARIADB_USER..."
echo "Done setting up MariaDB"

mariadb-admin shutdown
exec mariadbd-safe
