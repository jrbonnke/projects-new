#!/bin/bash

# Update package lists
sudo apt update

# Install Apache
sudo apt install -y apache2

# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Source NVM script to start using it in this shell session
source ~/.bashrc

# Install Node.js version 16.20.0
nvm install 16.20.0

# Set Node.js version 16.20.0 as the default
nvm alias default 16.20.0

# Install pm2
npm install -g pm2

#install angular cli globally
npm install -g @angular/cli

# Start Apache
sudo systemctl start apache2

# Output installed versions for verification
echo "Installed versions:"
echo "Apache:"
apache2 -v
echo "Node.js:"
node -v
echo "npm:"
npm -v
echo "pm2:"
pm2 -v

echo "Installation completed."
