#!/usr/bin/env bash

# This function is to check whether teh user is root or normal user----------------------------------------------------
CheckRootUser()
{
USER_ID=$(id -u)

if [ "$USER_ID" -ne "0" ]; then
  echo Hi You are supposed to be a root user or sudo user toi run the script
  exit
else
  echo Running the Script, Script Execution in Progresss...........
fi
}

#-----------------------------------------------------------------------------------------------------------------------

#This function is to check that the command has been successfully executed or not---------------------------------------
CheckStatus()
{
  if [ "$?" -eq  "0" ]; then
     echo -e "----SUCCESS----\n"
  else
    echo -e "----FAILURE----\n"
    echo -e "Check Error Log for more info!!!!!!!!\n"
 fi
}
#-----------------------------------------------------------------------------------------------------------------------

# This global variable is to creat and reuse the log file acoos the project
LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
#-----------------------------------------------------------------------------------------------------------------------

#This function redirects the output to the log file aswell to check status of each and every step-----------------------
ECHO()
{
  echo -e "=========================== $1 ===========================\n" >>${LOG_FILE}
  echo "$1"
}
#-----------------------------------------------------------------------------------------------------------------------

NODEJS()
{
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
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
CheckStatus $?

ECHO "Moving to roboshop folder and unzipping the file"
cd /home/roboshop && rm -rf ${COMPONENT} &>>${LOG_FILE} && unzip /tmp/${COMPONENT}.zip &>>${LOG_FILE} && mv ${COMPONENT}-main ${COMPONENT}
CheckStatus $?

#ECHO "Moving ${COMPONENT}-main folder to ${COMPONENT}"
#mv ${COMPONENT}-main ${COMPONENT} &>>${LOG_FILE}
#CheckStatus $?

ECHO "change directory to ${COMPONENT} directory"
cd /home/roboshop/${COMPONENT} &>>${LOG_FILE}
CheckStatus $?

ECHO "Installing nodejs files"
npm install &>>${LOG_FILE}
CheckStatus $?

#Note: As we have run the above commands as root user we need to set the permissions to the Application user to access these files

ECHO "Changing Permissions"
chown roboshop:roboshop /home/roboshop/${COMPONENT} -R &>>${LOG_FILE}
CheckStatus $?

ECHO "Update SystemD file with correct IP addresse"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE} -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE} -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE}
CheckStatus $?

ECHO "Setup Systemd"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
systemctl daemon-reload &>>${LOG_FILE} && systemctl start ${COMPONENT} &>>${LOG_FILE} && systemctl enable ${COMPONENT} &>>${LOG_FILE}
CheckStatus $?
}
