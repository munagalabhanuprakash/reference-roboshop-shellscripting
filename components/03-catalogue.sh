#!/usr/bin/env bash

source components/00commons.sh
CheckRootUser


ECHO "Downloading NodeJS, Installing NodeJS and Compiler"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
yum install nodejs gcc-c++ -y &>>${LOG_FILE}
CheckStatus $?

ECHO "Removing any existing roboshop user and Adding roboshop User"
# userdel roboshop &>>${LOG_FILE}
useradd roboshop &>>${LOG_FILE}
CheckStatus $?

#ECHO "Switching to User"
#id roboshop
#if [ $? -ne "0"]; then
#  echo "Adding Application user (roboshop)"
#  useradd roboshop &>>${LOG_FILE}
#  CheckStatus $?
#fi

