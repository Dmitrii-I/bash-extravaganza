#!/bin/bash

process_name=$1
timestamp=$(date --utc +"%F %T.%N UTC") # yes we also want nanosecond; just because we can
stats=$(\ps -C $process_name -o pid,cmd,start,pcpu,pmem,cputime,thcount,rsz,vsz,state)


# prepend the timestamp to each line
sed -e "s/^/$timestamp /" <<< "$stats"



