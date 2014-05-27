#!/bin/bash

# This script is a poor man's service supervise (program in the package daemontools).
# I needed something very simple and supervise was too bloated for my purpose
#
# The script takes as argument a command to execute, and runs the command again within
# 3 seconds if it exits. Some basic logging is done as well To daemonize this 
# script we put braces # around it and end with ampersand. Learned this trick here: 
# http://stackoverflow.com/questions/3430330/best-way-to-make-a-shell-script-daemon
#
# Example usage: 
# ./keep-running.sh python ./script-that-needs-to-run-forever.py somearg1 somearg2

LOG="./keep-running.log"
CMD_TO_RUN="$@"
COUNTER=1

(
while true; do
        timestamp=$(date +"%Y-%m-%d %H:%M:%S.%N")
        echo -ne "$timestamp\t" >> $LOG
        echo -ne "keep-running.sh\tGoing to continuosly run $CMD_TO_RUN\n" >> $LOG
        "$CMD_TO_RUN" &> /dev/null
        sleep 3
        echo -ne "$timestamp\t" >> $LOG
        echo -ne "keep-running.sh\tInstance #$COUNTER of $CMD_TO_RUN quit. Starting new instance\n" >> $LOG
        # bonus: send an email to ourselves 
        echo "keep-running.sh: $CMD_TO_RUN has stopped. It has been started again." | ssmtp root &
        let "COUNTER=COUNTER+1"        
done &> /dev/null
) &



