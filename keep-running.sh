#!/bin/bash

# This script is a lazy man's daemon: just run the program forever
# and that is it. If the program exits, wait 3 seconds and start it again. Some basic 
# logging is done, so we are not totally lazy. To daemonize the program that
# has to run forever, put the braces around it and end with ampersand. This trick
# is explained here: 
# http://stackoverflow.com/questions/3430330/best-way-to-make-a-shell-script-daemon
# The daemonized program will run under parent PID of this script, while this script
# will have parent PID 1.
#
# Arguments: a command/script/program that should run forever. 
#
# Example usage: 
# ./keep-running.sh python ./script-that-needs-to-run-forever.py somearg1 somearg2
# Note that it is important that you refer to the script that needs to be run forever with
# a relative path if it is not in your $PATH.
#
# To stop running forever, simply kill this script and the program

LOG="./keep-running.log"
CMD_TO_RUN="$@"
COUNTER=1 # how many times the we have started the program

(
while true; do
        timestamp=$(date +"%Y-%m-%d %H:%M:%S.%N")
        echo -ne "$timestamp\t" >> $LOG
        echo -ne "keep-running.sh\tAttempt #$COUNTER. Going to continuosly run: $CMD_TO_RUN\n" >> $LOG
        $CMD_TO_RUN &> /dev/null
        sleep 3
        echo -ne "$timestamp\t" >> $LOG
        echo -ne "keep-running.sh\tInstance #$COUNTER of $CMD_TO_RUN quit. Starting new instance\n" >> $LOG
        # bonus: send an email to ourselves 
        echo "keep-running.sh: $CMD_TO_RUN has stopped. It has been started again." | ssmtp root &
        let "COUNTER=COUNTER+1"        
done &> /dev/null
) &
