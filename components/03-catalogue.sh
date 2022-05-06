#!/usr/bin/env bash

source components/00-common.sh
CheckRootUser


ECHO "Configure NodeJS Repos "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}

ECHO "Installing NodeJS and Compiler"
yum install nodejs gcc-c++ -y &>>${LOG_FILE}
CheckStatus $?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
    echo "Adding Application(roboshop) user"
    useradd roboshop &>>${LOG_FILE}
fi

ls -l
# Note: Here We are checking whether the roboshop user already exists or not by checking the status code (0 if Exists and Non zero if user exists)and if not we are creating one




