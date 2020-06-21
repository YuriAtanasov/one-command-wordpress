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
sudo sed -i '39i define( '"'"'WP_HOME'"'"', '"'"'${wordpress_eip}'"'"' );' wp-config.php
sudo sed -i '40i define( '"'"'WP_SITEURL'"'"', '"'"'${wordpress_eip}'"'"' );' wp-config.php
sudo wp core install --url=http://${wordpress_eip} --title=WordPress --admin_user=wordpress --admin_password=${wordpress_admin_password} --admin_email=test@test.com --allow-root
echo "Namespaces are a feature of the Linux kernel that partitions kernel resources such that one set of processes sees one set of resources while another set of processes sees a different set of resources. The feature works by having the same namespace for these resources in the various sets of processes, but those names referring to distinct resources. Examples of resource names that can exist in multiple spaces, so that the named resources are partitioned, are process IDs, hostnames, user IDs, file names, and some names associated with network access, and interprocess communication.

Namespaces are a fundamental aspect of containers on Linux.

The term "namespace" is often used for a type of namespace (e.g. process ID) as well for a particular space of names.

A Linux system starts out with a single namespace of each type, used by all processes. Processes can create additional namespaces and join different namespaces." > /home/ubuntu/body.txt
sudo wp post create /home/ubuntu/body.txt --post_status=publish --post_title='Linux namespaces' --allow-root
sudo wp post delete 1 --force --allow-root
sudo service apache2 restart