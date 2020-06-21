#!/bin/bash
sudo apt update
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password ${root_password}'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password ${root_password}'
sudo apt install mysql-server -y
sudo apt install expect -y
tee ~/secure_mysql.sh > /dev/null << EOF

  spawn $(which mysql_secure_installation)

  # Enter the password for user root
  expect "Enter the password for user root:"
  send ${root_password}
  send "\r"

  # Would you like to setup the validate Password Plugin?
  expect "Press y|Y for Yes, any other key for No:"
  send "n\r"

  # Change the password for root?
  expect "Change the password for root ? ((Press y|Y for Yes, any other key for No) :"
  send "n\r"

  # Remove anonymous users
  expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
  send "y\r"

  # Disallow remote root login
  expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
  send "y\r"

  # Remove test DB?
  expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
  send "y\r"

  # Reload privilege tables
  expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) :"
  send "y\r"

  expect eof
EOF
sudo expect ~/secure_mysql.sh
sudo mysql -e "CREATE DATABASE wordpress;" -p${root_password}
sudo mysql -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY '${wordpress_password}';" -p${root_password}
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '${wordpress_password}';" -p${root_password}
sudo mysql -e "GRANT ALL ON wordpress.* TO wordpress@'${web_ip_1}' IDENTIFIED BY '${wordpress_password}';" -p${root_password}
sudo mysql -e "GRANT ALL ON wordpress.* TO wordpress@'${web_ip_2}' IDENTIFIED BY '${wordpress_password}';" -p${root_password}
sudo mysql -e "FLUSH PRIVILEGES;" -p${root_password}
sudo sed -i "s/.*bind-address.*/#bind-address = 127.0.0.1/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart

cat <<EOT >> /home/ubuntu/optimize.sh
#!/bin/bash

echo "Wordpress database tables' size BEFORE optimize are:"

mysql -uwordpress -p${wordpress_password} <<MY_QUERY
USE wordpress
SELECT table_name AS "Table",
ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)"
FROM information_schema.TABLES
WHERE table_schema = "wordpress"
ORDER BY (data_length + index_length) DESC;
MY_QUERY

echo "Running optimization"

mysqlcheck -os -uwordpress -p${wordpress_password} wordpress

echo "Wordpress database tables' size AFTER optimize are:"

mysql -u -uwordpress -p${wordpress_password} <<MY_QUERY
USE wordpress
SELECT table_name AS "Table",
ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)"
FROM information_schema.TABLES
WHERE table_schema = "wordpress"
ORDER BY (data_length + index_length) DESC;
MY_QUERY
EOT
chmod a+x /home/ubuntu/optimize.sh
sudo crontab -l > optimize
sudo echo "0 0 * * SUN /home/ubuntu/optimize.sh > /var/log/db-optimize\$(date +\%d-\%m-\%Y).log" >> optimize
sudo crontab optimize
sudo rm optimize