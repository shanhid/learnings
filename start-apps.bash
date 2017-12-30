#!/bin/bash
#---------------------------------------------------------------------------------------------------#
#
#  Component : start-apps.sh
#  Author    : Sankarkumar Shanmugagani
#  Copyright:  HID Global, 2018
#
#-----------------------------------------------------------------------------------------------------#
#Description
#----------------
#  
#  This wrapper script is meant to start the java based TMT ticketing applications on EC2 Linux instance. 
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
JAR[0]=eventandticketholder.jar
JAR[1]=issuancesystem.jar

die()
{
  echo $1
  echo "Processing terminated"
  exit $BAD_RUN
}

main()
{
echo "----------------------------------------"
echo "Execution started: start-apps.sh with pid - $$ - on `date +"%m%d%Y%H%M%S"`"
for i in ${JAR[@]}
do
  cmd="java -jar $i"
  echo "Command to be executed: $cmd"
  $cmd
  ec=$?
  if [ $ec -eq 0 ]; then
    echo "Command execution successful"
  else
    die "Command execution failed with exit code - $ec"
  fi
done
echo "Execution complete: start-apps.sh with pid - $$ - on `date +"%m%d%Y%H%M%S"`"
echo "----------------------------------------"
}

main