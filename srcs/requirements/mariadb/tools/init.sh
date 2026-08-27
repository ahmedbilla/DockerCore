#!/bin/bash


if [ ! -d "/var/lib/mysql/${DB_NAME}" ]; then

    mysql_install_db --user=mysql --datadir=/var/lib/mysql


    mariadbd --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${DB_ROOT_PASSWORD}');
FLUSH PRIVILEGES;
EOF

fi

exec mariadbd --user=mysql