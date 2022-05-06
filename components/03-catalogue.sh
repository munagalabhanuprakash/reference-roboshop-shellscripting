#!/usr/bin/env bash

source components/00-common.sh
CheckRootUser


ECHO "Configure NodeJS Repos "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}

ECHO "Installing NodeJS and Compiler"
yum install nodejs gcc-c++ -y &>>${LOG_FILE}
CheckStatus $?

ECHO "Removing any existing roboshop user and Adding roboshop User"
# userdel roboshop &>>${LOG_FILE}
useradd roboshop &>>${LOG_FILE}
CheckStatus $?

ECHO "Add Application User"
useradd roboshop &>>${LOG_FILE}
CheckStatus $?


