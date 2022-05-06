#!/usr/bin/env bash

source components/00-common.sh
CheckRootUser

ECHO "Installing Webserver NGINX"
yum install nginx -y &>>${LOG_FILE}
CheckStatus $?

ECHO "Enabling and Startting Webserver NGINX"
systemctl enable nginx &>>${LOG_FILE} && systemctl start nginx &>>${LOG_FILE}
CheckStatus $?

ECHO "Downloading Frontend Code"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}
CheckStatus $?

ECHO "Moving to the HTML folder of Webserver"
cd /usr/share/nginx/html &>>${LOG_FILE}
CheckStatus $?

ECHO "Removing Old Files"
rm -rf * &>>${LOG_FILE}
CheckStatus $?

ECHO "Extracting the content"
unzip /tmp/frontend.zip &>>${LOG_FILE}
CheckStatus $?

ECHO "Copying Extracted Content"
mv frontend-main/* . &>>${LOG_FILE} && mv static/* . &>>${LOG_FILE} && rm -rf frontend-main README.md &>>${LOG_FILE}
CheckStatus $?

ECHO "Copy RoboShop NGINX Config"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
CheckStatus $?

ECHO "Update Nginx Configuration"
sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' /etc/nginx/default.d/roboshop.conf -e '/user/ s/localhost/user.roboshop.internal/' /etc/nginx/default.d/roboshop.conf -e '/cart/ s/localhost/cart.roboshop.internal/' /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
CheckStatus $?

ECHO "restarting the NGINX Webserver"
systemctl restart nginx &>>${LOG_FILE}
CheckStatus $?