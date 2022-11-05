#!/bin/bash
set -e

chown -R mysql:mysql /var/lib/mysql
mysql_install_db --user mysql > /dev/null

MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-"Gmd123456**"}
MYSQL_DATABASE=${MYSQL_DATABASE:-"darwindb"}
MYSQL_USER=${MYSQL_USER:-"darwin"}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-"Gmd123456*1"}

tfile=`mktemp`
if [[ ! -f "$tfile" ]]; then
    return 1
fi


cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("$MYSQL_ROOT_PASSWORD") WHERE user='root';

FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'darwin'@'%' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("$MYSQL_PASSWORD") WHERE user='darwin';
EOF

if [[ $MYSQL_DATABASE != "" ]]; then
    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

    if [[ $MYSQL_USER != "" ]]; then
        echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
    fi
fi

/usr/sbin/mysqld --bootstrap --verbose=0 < $tfile
rm -f $tfile


exec /usr/sbin/mysqld