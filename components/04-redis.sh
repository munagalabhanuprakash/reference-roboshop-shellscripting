#!/usr/bin/env bash

source /home/centos/roboshop/components/00-common.sh
CheckRootUser

ECHO "Configuring redis repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo

# yum install redis-6.2.7 -y

# systemctl enable redis
# systemctl start redis

