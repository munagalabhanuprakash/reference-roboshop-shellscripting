!/usr/bin/env bash

source components/00-common.sh
CheckRootUser

ECHO "Installing Golang"
yum install golang -y &>>${LOG_FILE}
CheckStatus $?

id roboshop &>>${LOG_FILE}
 if [ $? -ne 0 ]; then
     echo "Adding Application(roboshop) user"
     useradd roboshop &>>${LOG_FILE}
 fi

curl -L -s -o /tmp/dispatch.zip https://github.com/roboshop-devops-project/dispatch/archive/refs/heads/main.zip &>>${LOG_FILE}
unzip /tmp/dispatch.zip &>>${LOG_FILE}
mv dispatch-main dispatch &>>${LOG_FILE}
cd dispatch &>>${LOG_FILE}
go mod init dispatch &>>${LOG_FILE}
go get &>>${LOG_FILE}
go build &>>${LOG_FILE}

ECHO "Changing Permissions"
chown roboshop:roboshop /home/roboshop/${COMPONENT} -R &>>${LOG_FILE}
CheckStatus $?
#
#mv /home/roboshop/dispatch/systemd.service /etc/systemd/system/dispatch.service
#systemctl daemon-reload
#systemctl enable dispatch
#systemctl start dispatch