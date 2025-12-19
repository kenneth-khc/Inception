#!/usr/bin/env bash

mariadb -u "$DB_USER" -p "$DB_PASSWORD" -e "SELECT 1;" || exit 1
