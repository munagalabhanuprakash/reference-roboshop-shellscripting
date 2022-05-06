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
CheckRootUser
#-----------------------------------------------------------------------------------------------------------------------
#
##This function is to check that the command has been successfully executed or not---------------------------------------
#CheckStatus()
#{
#  if [ "$?" -eq  "0" ]; then
#     echo -e "----SUCCESS----\n"
#  else
#    echo -e "----FAILURE----\n"
#    echo Check Error Log for more info
# fi
#}
##-----------------------------------------------------------------------------------------------------------------------
#
## This global variable is to creat and reuse the log file acoos the project
#LOG_FILE=/tmp/roboshop.log
#rm -f $LOG_FILE
##-----------------------------------------------------------------------------------------------------------------------
#
##This function redirects the output to the log file aswell to check status of each and every step-----------------------
#ECHO()
#{
#  echo -e "=========================== $1 ===========================\n" >>${LOG_FILE}
#  echo "$1"
#}
##-----------------------------------------------------------------------------------------------------------------------