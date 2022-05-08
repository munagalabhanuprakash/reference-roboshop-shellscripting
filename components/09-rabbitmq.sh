#!/usr/bin/env bash

source components/00-common.sh
CheckRootUser

ECHO "Setup YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG_FILE}
CheckStatus $?

ECHO "Install RabbitMQ & Erlang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG_FILE}
CheckStatus $?

ECHO "Start RabbitMQ Service"
systemctl enable rabbitmq-server &>>${LOG_FILE}  && systemctl start rabbitmq-server &>>${LOG_FILE}
CheckStatus $?

rabbitmqctl list_users | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  ECHO "Create an Application User"
  rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
  CheckStatus $?
fi

ECHO "Setup Application User Persmissions"
rabbitmqctl set_user_tags roboshop administrator  &>>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>${LOG_FILE}
CheckStatus $?
