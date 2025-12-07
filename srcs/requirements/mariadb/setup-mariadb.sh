#!/usr/bin/env bash

echo "Setting up MariaDB..."
mariadbd-safe --no-watch

attempt=0
max_attempts=10
mariadb_unix_socket='/run/mysqld/mysqld.sock'
until socat -u OPEN:/dev/null UNIX-CONNECT:"$mariadb_unix_socket" 2>/dev/null
  do
    attempt=$((attempt + 1))
    echo "Waiting for $mariadb_unix_socket... (attempt $attempt/$max_attempts)"

    if [[ $attempt -ge $max_attempts ]]; then
      echo "Could not connect to $mariadb_unix_socket after $max_attempts attempts. Exiting."
      exit 1
    fi

    sleep 1
  done

exitOnError() {
  echo "Something went wrong. Exiting." >&2
  exit 1
}
trap exitOnError ERR

DB_PASSWORD=$(cat "$DB_PASSWORD_FILE")
echo "Creating user $DB_USER..."
mariadb -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mariadb -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mariadb -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
mariadb -e "FLUSH PRIVILEGES;"
echo "Done creating user $DB_USER..."
echo "Done setting up MariaDB"

mariadb-admin shutdown
exec mariadbd-safe
