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

curl -L -s -o /tmp/dispatch.zip https://github.com/roboshop-devops-project/dispatch/archive/refs/heads/main.zip
unzip /tmp/dispatch.zip
mv dispatch-main dispatch
cd dispatch
go mod init dispatch
go get
go build

ECHO "Changing Permissions"
chown roboshop:roboshop /home/roboshop/${COMPONENT} -R &>>${LOG_FILE}
CheckStatus $?

mv /home/roboshop/dispatch/systemd.service /etc/systemd/system/dispatch.service
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch