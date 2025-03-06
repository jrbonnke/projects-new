#!/bin/bash

# Update package index
sudo apt update

# Install MySQL Server
sudo apt install -y mysql-server

# Install phpMyAdmin and PHP dependencies
sudo apt install -y phpmyadmin php-mbstring php-gettext

# Enable PHP mcrypt extension
sudo phpenmod mcrypt

# Restart Apache server to apply changes
sudo systemctl restart apache2

# Configure phpMyAdmin to work with Apache
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin.conf

# Restart Apache server
sudo systemctl restart apache2

# Set MySQL root password (if not already set during installation)
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_root_password';"

# Create a MySQL user and set a password
MYSQL_USER="root"
MYSQL_PASSWORD="Password"
sudo mysql -e "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_PASSWORD';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'localhost' WITH GRANT OPTION;"

echo "MySQL and phpMyAdmin installation completed."
echo "MySQL user '$MYSQL_USER' created with password '$MYSQL_PASSWORD'."
