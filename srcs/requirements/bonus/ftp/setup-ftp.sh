#!/usr/bin/env bash

## create a user meant for FTP logins

CREDENTIALS=/run/secrets/ftp-user-credentials

if [[ ! -f $CREDENTIALS ]]; then
  echo "Missing FTP user credentials. Exiting." >&2
  exit 1
fi

echo "Reading FTP user credentials..."
USERNAME=$(awk -F= '$1=="FTP_USER_NAME" {print $2}' $CREDENTIALS)
PASSWORD=$(awk -F= '$1=="FTP_USER_PASSWORD" {print $2}' $CREDENTIALS)

echo "Creating FTP user..."
groupadd "$USERNAME"
useradd "$USERNAME" \
        --gid "$USERNAME" \
        --groups inception_ftp \
        --create-home
echo "$USERNAME:$PASSWORD" | chpasswd
echo "Successfully created FTP user."

echo "Starting vsftpd."
exec vsftpd /etc/vsftpd.conf
