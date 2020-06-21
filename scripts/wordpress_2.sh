#!/bin/bash
sudo apt update
sudo apt install php php-mysql libapache2-mod-php -y
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
wp --info
cd /var/www/html/
sudo rm index.html
sudo wp core download --allow-root
sudo cp wp-config-sample.php wp-config.php
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sleep 60
sudo perl -pi -e "s/database_name_here/wordpress/g" wp-config.php
sudo perl -pi -e "s/username_here/wordpress/g" wp-config.php
sudo perl -pi -e "s/localhost/${mysql_ip}/g" wp-config.php
sudo perl -pi -e "s/password_here/${wordpress_mysql_password}/g" wp-config.php
sudo sed -i '39i define( '"'"'WP_HOME'"'"', '"'"'${wordpress_alb}'"'"' );' wp-config.php
sudo sed -i '40i define( '"'"'WP_SITEURL'"'"', '"'"'${wordpress_alb}'"'"' );' wp-config.php
sudo wp core install --url=http://${wordpress_alb} --title=WordPress --admin_user=wordpress --admin_password=${wordpress_admin_password} --admin_email=test@test.com --allow-root
sudo service apache2 restart