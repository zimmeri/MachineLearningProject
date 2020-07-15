sudo apt-get -y update


#node and npm
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get update
sudo apt-get -y install nodejs
sudo npm install -g npx

#python and pip
sudo apt-get install python3
sudo apt-get -y install python3-pip


# mysql 8.0
export DEBIAN_FRONTEND="noninteractive"
mypass=$1
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-server select mysql-8.0'
wget https://dev.mysql.com/get/mysql-apt-config_0.8.10-1_all.deb
sudo -E dpkg -i mysql-apt-config_0.8.10-1_all.deb
sudo apt-key adv --recv-keys --keyserver ha.pool.sks-keyservers.net 5072E1F5 && sudo apt-get update

# install mysql
set1="mysql-community-server mysql-community-server/re-root-pass password "
set2="mysql-community-server mysql-community-server/root-pass password "
set3="mysql-server mysql-server/root_password password "
set4="mysql-server mysql-server/root_password_again password "
sudo debconf-set-selections <<< $set1$mypass
sudo debconf-set-selections <<< $set2$mypass
sudo debconf-set-selections <<< $set3$mypass
sudo debconf-set-selections <<< $set4$mypass
sudo debconf-set-selections <<< "mysql-community-server mysql-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)"
sudo -E apt-get -y install mysql-server

# create and import database
echo "create database main;" | mysql -u root -p$mypass
echo "create user 'admin'@'localhost' IDENTIFIED BY '$mypass';" | mysql -u root -p$mypass
echo "grant all privileges on main.* TO 'admin'@'localhost';" | mysql -u root -p$mypass
echo "create user 'guest'@'%' IDENTIFIED BY '$mypass';" | mysql -u root -p$mypass
echo "grant all privileges on main.* TO 'guest'@'%';" | mysql -u root -p$mypass
echo "ALTER USER 'admin'@'localhost' IDENTIFIED WITH mysql_native_password BY '$mypass';" | mysql -u root -p$mypass
mysql -u root -p$mypass main < /home/vagrant/home/db/main.sql

#pip dependencies
