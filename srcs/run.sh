#!/bin/bash

# ssl
openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Student/CN=localhost" -keyout localhost.key -out localhost.crt
mv localhost.crt /etc/ssl/certs
mv localhost.key /etc/ssl/private
chmod 600 /etc/ssl/certs/localhost.crt /etc/ssl/private/localhost.key

# nginx default set(ssl, autoindex, php)
cp -rp /tmp/default /etc/nginx/sites-available/default

# phpMyAdmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.zip
unzip phpMyAdmin-5.1.0-all-languages.zip
rm phpMyAdmin-5.1.0-all-languages.zip
mv phpMyAdmin-5.1.0-all-languages phpmyadmin
mv phpmyadmin /var/www/html
cp -rp /tmp/config.inc.php /var/www/html/phpmyadmin

# DB set
service mysql start
mysql < /var/www/html/phpmyadmin/sql/create_tables.sql -u root --skip-password
echo "CREATE DATABASE wordpress;" \
    | mysql
echo "CREATE USER 'sujeon'@'localhost' IDENTIFIED BY '1234';" \
    | mysql
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'sujeon'@'localhost' WITH GRANT OPTION;" \
    | mysql

# Wordpress
wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
rm latest.tar.gz
mv wordpress /var/www/html
chown -R www-data:www-data /var/www/html/wordpress
cp -rp /tmp/wp-config.php /var/www/html/wordpress

# service
service nginx start
service php7.3-fpm start
service php7.3-fpm status
service mysql reload

bash