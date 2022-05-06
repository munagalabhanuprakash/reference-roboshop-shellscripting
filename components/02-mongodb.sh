#!/usr/bin/env bash

source components/00-common.sh
CheckRootUser

ECHO "Setup mongodb Repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG_FILE}
CheckStatus $?

ECHO "Installing mongodb-org"
yum install -y mongodb-org &>>${LOG_FILE}
CheckStatus $?

ECHO "Enabling and Starting mongodb"
systemctl enable mongod &>>${LOG_FILE} && systemctl start mongod &>>${LOG_FILE}
CheckStatus $?

ECHO "Configure Listen Address in monogdb Configuration"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG_FILE}
CheckStatus $?

ECHO "Restarting mongodb"
systemctl restart mongod &>>${LOG_FILE}
CheckStatus $?

ECHO "Downloading the Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>${LOG_FILE}
CheckStatus $?

ECHO "Moving to temp Folder"
cd /tmp &>>${LOG_FILE}
CheckStatus $?

ECHO "Unzipping Schema"
unzip -o mongodb.zip &>>${LOG_FILE}
CheckStatus $?

ECHO "Moving to mongodb-main"
cd /mongodb-main &>>${LOG_FILE}
CheckStatus $?
#
#ECHO "Load Schema"
#mongo < catalogue.js &>>${LOG_FILE} && mongo < users.js &>>${LOG_FILE}