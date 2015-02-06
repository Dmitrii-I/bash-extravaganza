#!/bin/bash

# This script is a lazy man's daemon: it makes sure some program is run forever.
# If the program exits, wait 3 seconds and start it again. If it exits again
# wait again 3 secons and start again, and so on. 
# To daemonize the program that has to run forever, put the braces around it
# and end with ampersand. This trick is explained here: 
# http://stackoverflow.com/questions/3430330/best-way-to-make-a-shell-script-daemon
#
# The daemonized program will run under parent PID of this script, while this script
# will have parent PID 1.
#
# Arguments: a program to run forever and its optional arguments.

# Example usage: 
# ./run-forever.sh python ./script-that-needs-to-run-forever.py somearg1 somearg2
#
# IMPORTANT: you need to refer to the program  that needs to be run forever with
# a relative path if it is not in your $PATH. If programs arguments contain
# paths, take care as well.
#
# To stop running forever, simply kill this script and the program

LOG="./run-forever.log"
CMD_TO_RUN="$@"
COUNTER=1 # how many times the we have started the program

(
while true; do
        timestamp=$(date +"%Y-%m-%d %H:%M:%S.%N")
        echo -ne "$timestamp\t" >> $LOG
        echo -ne "run-forever.sh\tAttempt #$COUNTER. Going to continuosly run: $CMD_TO_RUN\n" >> $LOG
        $CMD_TO_RUN &> /dev/null
        sleep 3
        echo -ne "$timestamp\t" >> $LOG
        echo -ne "run-forever.sh\tInstance #$COUNTER of $CMD_TO_RUN quit. Starting new instance\n" >> $LOG
        # bonus: send an email to ourselves 
        echo "run-forever.sh: $CMD_TO_RUN has stopped. It has been started again." | ssmtp root &
        let "COUNTER=COUNTER+1"        
done &> /dev/null
) &
