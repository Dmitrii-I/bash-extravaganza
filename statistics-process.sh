#!/bin/bash

# This script prints the ps command in custom format, prepended with a timestamp.
# It is meant to run say every minute as a cron job and append its output to a logfile.
# From the logfile we can extract useful time series like CPU usage over time, 
# or the virtual memory size over time. 
#
# Arguments: the name of the process
# Usage example: ./statistics-process.sh python

process_name=$1
timestamp=$(date --utc +"%F %T.%N UTC") # yes we also want nanosecond; just because we can
stats=$(ps -C $process_name -o pid,cmd,start,pcpu,pmem,cputime,rsz,vsz,state)

# prepend the timestamp to each line and print to stdout
sed -e "s/^/$timestamp /" <<< "$stats"
