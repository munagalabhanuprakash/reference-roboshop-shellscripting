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

# I have to grab the default password from the mysqld.log file for this i execute the grep command fist
# observe the output then take a unique keyword from teh default password line which is unique to that
# line itself and then use the awk command to grab it and set it to default as variable.
# [ centos@mysql ~/roboshop ]$ sudo grep temp /var/log/mysqld.log
  # 2022-05-06T17:37:48.179239Z 1 [Note] A temporary password is generated for root@localhost: >!SZhS7ru>>b
  # 2022-05-06T17:37:51.246955Z 0 [Note] InnoDB: Creating shared tablespace for temporary tables
  # [ centos@mysql ~/roboshop ]$ sudo grep 'A temporary password' /var/log/mysqld.log
  # 2022-05-06T17:37:48.179239Z 1 [Note] A temporary password is generated for root@localhost: >!SZhS7ru>>b
  #[ centos@mysql ~/roboshop ]$ sudo grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}'

ECHO "grabbing the default password and pass it on to a file"
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

# Now we need to login to sql and change the password for this i woudl login with default password
# using mysql -uroot -p${DEFAULT_PASSWORD} and then run the sql specific command
# (ALTER USER 'user'@'hostname' IDENTIFIED BY 'newPass';)
# to change the password and pass it on into a file using input redirector and send that to mysql as a file
# in the above sql command change user to root and hotname to localhost

echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';">/tmp/root-pass.sql

# Here in teh next step teh command mysql --connect-expired-password -u root -p${DEFAULT_PASSWORD} </tmp/root-pass.sql &>>${LOG_FILE}
#runs fine for the first time but when we rerun teh command it fails because the default password has already been reset
# and the command fails so to over come this we set a if condition to check if teh password is working and is showing
# the database connection then proceed otherwise rest password

echo show databases | mysql -uroot -pRoboShop@1 &>>$LOG_FILE
if [ $? -ne 0 ]; then
  ECHO "Reset MySQL Password"
  mysql --connect-expired-password -u root -p${DEFAULT_PASSWORD} </tmp/root-pass.sql &>>${LOG_FILE}
  statusCheck $?
fi



# > uninstall plugin validate_password;

# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"

# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql

