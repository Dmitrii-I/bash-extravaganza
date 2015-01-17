#!/bin/bash

# Bash library containing generic functions

# todo
# function to insert thousand separator into numbers



# Functions

timestamp() {
	date +"%Y-%m-%d %H:%M:%S.%N"
}

is_login_shell() {
	if shopt -q login_shell; then return 0; else return 1; fi
}

is_empty() {
        # Returns true if its one and only argument is empty
        # Example usage: x=""; if is_empty $x; then echo empty; else echo not empty; fi
        [ -z "$1" ] && return 0 || return 1
}


is_interactive_shell() {
        [ -z "$PS1" ] && return 1 || return 0
}

closed_files() {
        # pattern should be between double quotes to prevent too early processing of meta-characters like *
        dir=${1:-.}
        pattern=${2:-*}
        all_files=$(find $dir -maxdepth 1 -type f -name "$pattern")

        # If there are no matched files, exit successfully, otherwise proceed
        [ -z "$all_files" ] && return 0 || all_files=$(echo "$all_files" | xargs -L1 basename)
        for file in $all_files; do
                num_file_handles=$(lsof -f -- $dir/$file | wc -l)
		if [ $num_file_handles -lt 1 ]; then echo $file; fi
        done
}

download_files() {
        while read -t 3 line; do
                scp -C "$line" .
        done
}


append()
{
        postfix="$1"
        while read -t 3 line; do
                echo "$line$postfix"
        done
}

prepend() {
        prefix="$1"
        while read -t 3 line; do
                echo "${prefix}${line}"
        done
}

s() {
        # This function sources this script
        source ~/bash-scripts/lib-bash-generic.sh
}

write_log() 
{
        # This function reads the variables $log, $script_name,
        # and $@ (all the arguments passed to it). It then 
        # constructs a tab-delimited one-line message and appends
        # it to $log.
        ts=$(timestamp)
        logmsg="$ts\tINFO\t$script_name\t$@\n"
        echo -ne "$logmsg" >> $log
}

date_sequence()
{
    now=`date +"%Y-%m-%d" -d "2014-08-01"` ; end=`date +"%Y-%m-%d" -d "2014-12-07"`; while [ "$now" != "$end" ] ; do now=`date +"%Y-%m-%d" -d "$now + 1 day"`;  echo "$now"; done
}
