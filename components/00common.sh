#!/usr/bin/env bash

# This function is to check whether teh user is root or normal user----------------------------------------------------
CheckRootUser()
{
USER_ID=$(id -u)

if [ "$USER_ID" -ne "0" ]; then
  echo HI You are supposed to be a root user or sudo user toi run the script
  exit
else
  echo Running the Script, Script Execution in Progresss...........
fi
}
#-----------------------------------------------------------------------------------------------------------------------

CheckRootUser