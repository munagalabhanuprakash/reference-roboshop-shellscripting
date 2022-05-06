#!/usr/bin/env bash

source components/00-common.sh
CheckRootUser

ECHO "Setup MySQL Repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
CheckStatus $?

ECHO "Install mysql"
yum install mysql-community-server -y &>>${LOG_FILE}
CheckStatus $?

ECHO "Enabling and Starting mysql"
systemctl enable mysqld &>>${LOG_FILE}
systemctl start mysqld &>>${LOG_FILE}
CheckStatus $?


# grep temp /var/log/mysqld.log

# mysql_secure_installation

# mysql -uroot -pRoboShop@1

# > uninstall plugin validate_password;

# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"

# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql

