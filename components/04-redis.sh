#!/usr/bin/env bash

source /home/centos/roboshop/components/00-common.sh
CheckRootUser

ECHO "Configuring redis repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
CheckStatus $?

ECHO "Installing redis-6.2.7"
yum install redis-6.2.7 -y &>>${LOG_FILE}
CheckStatus $?

#ECHO "Updating Bind ip in /etc/redis.conf and /etc/redis/redis.conf"
#sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf

# systemctl enable redis
# systemctl start redis

