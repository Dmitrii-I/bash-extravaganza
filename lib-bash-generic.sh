#!/bin/bash

# Bash library containing generic functions


# Aliases
alias newline_to_space='tr "\n" " "'



# Functions

newline_to_space2() 
{
        while read line; do  echo -n "$line "; done
}



timestamp() {
	date +"%Y-%m-%d %H:%M:%S.%N"
}

is_login_shell() {
	if shopt -q login_shell; then return 0; else return 1; fi
}

is_interactive_shell() {
        [ -z "$PS1" ] && return 1 || return 0
}

closed_files() {
        # pattern should be between double quotes to prevent too early processing of meta-characters like *
        dir=${1:-.}
        pattern=${2:-*}
        all_files=$(find $dir -maxdepth 1 -type f -name "$pattern" | xargs -L1 basename)
        for file in $all_files; do
                num_file_handles=$(lsof -f -- $dir/$file | wc -l)
                [ $num_file_handles -lt 1 ] && echo $file
        done
}

download_files() {
        while read -t 3 line; do
                scp -C "$line" .
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
