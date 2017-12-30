#!/bin/bash
#---------------------------------------------------------------------------------------------------#
#
#  Component : healthcheck.sh
#  Author    : Sankarkumar Shanmugagani
#  Copyright:  HID Global, 2018
#
#-----------------------------------------------------------------------------------------------------#
#Description
#----------------
#  
#  This wrapper script is meant to validate the health of the TMT ticketing applications running on EC2 linux. 
#  This is done by hitting the app healthcheck api - (for e.g: http://devtest.ticketing.hidglobal.com:7070/api/ping)
#  
#  Execution Mode: AWS CodeDeploy using AppSpec.yml hooks
#
#  Read more about CodeDeploy hooks -
#  http://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html#appspec-hooks-server
# 
#  Note: At the time of this writing, AppSpec.yml does not support passing cmd line arguments to the hooks.
#  
#--------------------------------------------------------------------------------------------------------#
# Constants
set -x
BAD_RUN=1
GOOD_RUN=0
URL[0]=http://localhost:7070/api/ping
URL[1]=http://localhost:6060/api/ping

die()
{
  echo $1
  echo "Processing terminated"
  exit $BAD_RUN
}

main()
{
echo "----------------------------------------"
echo "Execution started: validate-apps.sh with pid - $$ - on `date +"%m%d%Y%H%M%S"`"
for i in ${URL[@]}
do
  cmd="curl -sI $i"
  echo "Command to be executed: $cmd"
  $cmd
  ec=$?
  if [ $ec -eq 0 ]; then
    echo "Command execution successful"
  else
    die "Command execution failed with exit code - $ec"
  fi
done
echo "Execution complete: validate-apps.sh with pid - $$ - on `date +"%m%d%Y%H%M%S"`"
echo "----------------------------------------"
}

main