#!/usr/bin/env bash

source components/00-common.sh
CheckRootUser


ECHO "Configure NodeJS Repos "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
CheckStatus $?

ECHO "Installing NodeJS and Compiler"
yum install nodejs gcc-c++ -y &>>${LOG_FILE}
CheckStatus $?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
    echo "Adding Application(roboshop) user"
    useradd roboshop &>>${LOG_FILE}
fi
# Note: Here We are checking whether the roboshop user already exists or not by checking the status code (0 if Exists and Non zero if user exists)and if not we are creating one

ECHO "Downloading the content"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
CheckStatus $?

ECHO "Moving to roboshop folder and unzipping the file"
cd /home/roboshop &>>${LOG_FILE} && rm -rf catalogue &>>${LOG_FILE} && unzip -o /tmp/catalogue.zip &>>${LOG_FILE}
CheckStatus $?

ECHO "Moving catalogue-main folder to catalogue"
mv catalogue-main catalogue &>>${LOG_FILE}
CheckStatus $?

ECHO "change directory to catalogue directory"
cd /home/roboshop/catalogue &>>${LOG_FILE}
CheckStatus $?

ECHO "Installing nodejs files"
npm install &>>${LOG_FILE}
CheckStatus $?

#Note: As we have run the above commands as root user we need to set the permissions to the Application user to access these files

ECHO "Changing Permissions"
chown roboshop:roboshop /home/roboshop/catalogue -R &>>${LOG_FILE}
CheckStatus $?

ECHO "Update SystemD file with correct IP addresse"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>${LOG_FILE}
CheckStatus $?

ECHO "Setup Systemd"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload &>>${LOG_FILE} && systemctl start catalogue &>>${LOG_FILE} && systemctl enable catalogue &>>${LOG_FILE}
CheckStatus $?
