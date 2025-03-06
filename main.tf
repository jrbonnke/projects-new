provider "aws" {
  region = "ap-south-1"
  access_key = ""
  secret_key = ""
}

# Generate a new private key
resource "tls_private_key" "example_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save the private key to a file
resource "local_file" "private_key_file" {
  filename = "/opt/private_key.pem"  # Replace with your desired path and file name
  content  = tls_private_key.example_key.private_key_pem
}



resource "aws_instance" "new-instance1" {
  ami           = "ami-0f5ee92e2d63afc18"  # Replace with desired AMI ID
  instance_type = "t2.micro"  # Replace desired instance type
  key_name      = "mykey"   # Replace with key pair name in AWS

  user_data = <<-EOF
#!/bin/bash

# Update package lists and install required packages
apt-get update -y
apt-get upgrade -y
apt-get install -y apache2 mysql-server php php-mysql phpmyadmin 

# Configure MySQL
mysql_secure_installation

# Configure Apache2 for phpMyAdmin
#sed -i '10i\'"Include /etc/phpmyadmin/apache.conf"  "/etc/apache2/apache2.conf"

echo "Include /etc/phpmyadmin/apache.conf" >> "/etc/apache2/apache2.conf"
#echo "Include /etc/phpmyadmin/apache.conf" | sudo tee -a /etc/apache2/apache2.conf

# Restart Apache2
systemctl restart apache2

# Output success message
echo "Installation completed successfully!"
EOF
vpc_security_group_ids = ["sg-094df81f11f31a1fb"] # Replace with created security group
  tags = {
    Name = "new-instance1" #add name of the instance 
  }


root_block_device{
volume_type = "gp2"
volume_size = 30 # Add storage size in GB
}
}
output "public_ip" {
  value = aws_instance.new-instance1.public_ip
}
